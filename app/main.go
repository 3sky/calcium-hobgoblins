package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

// Greetings ...
type Greetings struct {
	Greet string `json:"greet"`
}

// Status ...
type Status struct {
	Status string `json:"status"`
}

func main() {
	// Echo instance
	e := echo.New()

	// Middleware
	e.Use(middleware.LoggerWithConfig(middleware.LoggerConfig{
		Format: "method=${method}, uri=${uri}, status=${status}\n",
	}))
	e.Use(middleware.Recover())

	// Routes
	e.GET("/", HelloHandler)
	e.GET("/status", StatusHandler)

	// Start server
	e.Logger.Fatal(e.Start(":1323"))
}

// HelloHandler ...
func HelloHandler(c echo.Context) error {
	return c.JSON(http.StatusOK, &Greetings{Greet: "Hello, World!"})
}

// StatusHandler ...
func StatusHandler(c echo.Context) error {
	return c.JSON(http.StatusOK, &Status{Status: "OK"})
}
