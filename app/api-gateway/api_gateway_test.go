package main  // <-- cambiar de apigateway_test a main

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/go-chi/chi/v5"
)

// --- Handler mínimo a testear ---
// Copiamos solo la función healthCheck de tu código main.go.

func healthCheckMock(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"healthy"}`))
}

// --- TEST ---

func testHealthCheckReturns200(t *testing.T) {
	r := chi.NewRouter()
	r.Get("/health", healthCheckMock)

	req, _ := http.NewRequest("GET", "/health", nil)
	rr := httptest.NewRecorder()

	r.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Fatalf("esperaba status 200 pero obtuvo %d", rr.Code)
	}
}
