// JavaScript for dynamic weather data loading and dark mode toggle
document.addEventListener("DOMContentLoaded", () => {
    const darkModeToggle = document.getElementById("dark-mode-toggle");
    const body = document.body;

    darkModeToggle.addEventListener("click", () => {
        body.classList.toggle("dark-mode");
    });

    const searchButton = document.getElementById("search-button");
    const cityInput = document.getElementById("city-input");

    searchButton.addEventListener("click", () => {
        const city = cityInput.value;
        if (city) {
            console.log(`Fetching weather data for ${city}...`);
            // Mock functionality - Replace with API calls
            document.getElementById("current-weather").innerHTML = `
                <div>
                    <h3>${city}</h3>
                    <p>Temperature: 25°C</p>
                    <p>Condition: Sunny</p>
                    <p>Humidity: 50%</p>
                    <p>Wind Speed: 10 km/h</p>
                </div>
            `;
            document.getElementById("forecast").innerHTML = `
                <div>
                    <h4>Day 1</h4>
                    <p>Min: 20°C, Max: 28°C</p>
                    <p>Condition: Cloudy</p>
                </div>
                <div>
                    <h4>Day 2</h4>
                    <p>Min: 18°C, Max: 26°C</p>
                    <p>Condition: Rainy</p>
                </div>
                <div>
                    <h4>Day 3</h4>
                    <p>Min: 22°C, Max: 30°C</p>
                    <p>Condition: Sunny</p>
                </div>
            `;
        } else {
            alert("Please enter a city name.");
        }
    });
});
