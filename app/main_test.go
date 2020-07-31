package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
)

var (
	g = Greetings{}
	s = Status{}
)

func TestGreetings(t *testing.T) {

	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	HelloHandler(c)

	if rec.Code != 200 {
		t.Errorf("Expected status code is %d, but it was %d instead.", http.StatusOK, rec.Code)
	}

	json.NewDecoder(rec.Body).Decode(&g)

	if g.Greet != "Hello, World!" {
		t.Errorf("Expected value is \"Hello, World!\", but it was %s instead.", g.Greet)
	}

}

func TestStatus(t *testing.T) {

	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/status", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	StatusHandler(c)

	if rec.Code != 200 {
		t.Errorf("Expected status code is %d, but it was %d instead.", http.StatusOK, rec.Code)
	}

	json.NewDecoder(rec.Body).Decode(&s)

	if s.Status != "OK" {
		t.Errorf("Expected value is \"OK\", but it was %s instead.", s.Status)
	}

}
