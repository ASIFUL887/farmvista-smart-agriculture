
function setRole(role, btn) {
    document.getElementById("role").value = role;

    let buttons = document.querySelectorAll(".role-toggle button");
    buttons.forEach(b => b.classList.remove("active"));
    btn.classList.add("active");

    let agriFields = document.getElementById("agronomistFields");
    agriFields.style.display = (role === "agronomist") ? "block" : "none";
}

function validateForm() {
    let role = document.getElementById("role").value;

    let pass = document.getElementById("password").value;
    let repass = document.getElementById("repassword").value;

    if (pass !== repass) {
        alert("Passwords do not match!");
        return false;
    }

    if (role === "agronomist") {
        let spec = document.querySelector("input[name='specialized']").value;
        let exp = document.querySelector("input[name='experienced']").value;

        if (spec === "" || exp === "") {
            alert("Please fill agronomist details!");
            return false;
        }
    }

    return true;
}

//for password in sign up form
function togglePassword(id) {
    let input = document.getElementById(id);

    if (input.type === "password") {
        input.type = "text";
    } else {
        input.type = "password";
    }
}


//dashboard
function setRole(role, btn) {
    document.getElementById("role").value = role;

    let buttons = document.querySelectorAll(".role-toggle button");
    buttons.forEach(b => b.classList.remove("active"));
    btn.classList.add("active");

    let agriFields = document.getElementById("agronomistFields");
    agriFields.style.display = (role === "agronomist") ? "block" : "none";
}
// ===============================
// WEATHER SYSTEM (FINAL VERSION)
// ===============================
// ===============================
// WEATHER SYSTEM (FINAL ADVANCED)
// ===============================

const API_KEY = "fc813f60c449d6dfb2a99535d1495430";
const CACHE_TIME = 10 * 60 * 1000; // 10 minutes

console.log("Weather script loaded ✅");

// ===============================
// UPDATE UI
// ===============================
function updateWeatherUI(data) {
    console.log("Weather data:", data);

    if (!data || !data.main || !data.weather) {
        document.getElementById("weather").innerHTML = "Weather error ❌";
        return;
    }

    let temp = Math.round(data.main.temp);
    let weather = data.weather[0].main;
    let description = data.weather[0].description;

    let wind = data.wind.speed;
    let humidity = data.main.humidity;

    // ===============================
    // ICON + CONDITION
    // ===============================
    let icon = "☀️";
    let condition = "Sunny";

    if (weather === "Clouds") {
        icon = "☁️";
        condition = "Cloudy";
    }
    else if (weather === "Rain") {
        icon = "🌧️";
        condition = "Rainy";
    }
    else if (weather === "Thunderstorm") {
        icon = "⛈️";
        condition = "Storm";
    }
    else if (weather === "Clear") {
        icon = "☀️";
        condition = "Sunny";
    }
    else if (["Haze","Mist","Fog","Smoke"].includes(weather)) {
        icon = "🌫️";
        condition = "Foggy";
    }

    // ===============================
    // RAIN POSSIBILITY (SMART LOGIC)
    // ===============================
    let rainChance = "Low 🌤️";

    if (humidity > 80) rainChance = "High 🌧️";
    else if (humidity > 60) rainChance = "Medium ☁️";

    // ===============================
    // TIME + GREETING
    // ===============================
    let now = new Date();
    let hours = now.getHours();
    let minutes = now.getMinutes().toString().padStart(2, '0');

    let greeting = "";
    if (hours >= 5 && hours < 12) greeting = "Good Morning ☀️";
    else if (hours < 17) greeting = "Good Afternoon 🌤️";
    else if (hours < 21) greeting = "Good Evening 🌆";
    else greeting = "Good Night 🌙";

    // ===============================
    // FINAL UI
    // ===============================
    document.getElementById("weather").innerHTML = `
        ${greeting} | ${icon} ${temp}°C | ${condition} <br>
        💧 Humidity: ${humidity}% | 🌬️ Wind: ${wind} m/s <br>
        🌧️ Rain Chance: ${rainChance} | 🕒 ${hours}:${minutes}
    `;
}

// ===============================
// FETCH BY COORDS
// ===============================
function getWeatherByCoords(lat, lon) {
    fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric`)
        .then(res => res.json())
        .then(data => {
            localStorage.setItem("weatherData", JSON.stringify(data));
            localStorage.setItem("weatherTime", Date.now());
            updateWeatherUI(data);
        })
        .catch(err => {
            console.error("Fetch error:", err);
            getWeatherByCity("Dhaka");
        });
}

// ===============================
// FALLBACK CITY
// ===============================
function getWeatherByCity(city) {
    fetch(`https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}&units=metric`)
        .then(res => res.json())
        .then(data => updateWeatherUI(data))
        .catch(err => {
            console.error("Fallback failed:", err);
            document.getElementById("weather").innerHTML = "Weather unavailable ❌";
        });
}

// ===============================
// MAIN FETCH
// ===============================
function fetchWeather() {
    if (!navigator.geolocation) {
        console.warn("Geolocation not supported");
        getWeatherByCity("Dhaka");
        return;
    }

    navigator.geolocation.getCurrentPosition(
        position => {
            let lat = position.coords.latitude;
            let lon = position.coords.longitude;

            getWeatherByCoords(lat, lon);
        },
        error => {
            console.warn("Location blocked, using fallback city...");
            getWeatherByCity("Dhaka");
        }
    );
}

// ===============================
// INIT WITH CACHE
// ===============================
function initWeather() {
    let cached = localStorage.getItem("weatherData");
    let cacheTime = localStorage.getItem("weatherTime");

    if (cached && cacheTime && (Date.now() - cacheTime < CACHE_TIME)) {
        console.log("Using cached weather ✅");
        updateWeatherUI(JSON.parse(cached));
    } else {
        console.log("Fetching new weather 🌍");
        fetchWeather();
    }
}

// ===============================
// RUN
// ===============================
document.addEventListener("DOMContentLoaded", initWeather);
