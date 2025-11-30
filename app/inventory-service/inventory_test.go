package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

// --- Handler mínimo a testear ---
// Copiado de tu main.go
func healthCheckMock(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"status":"healthy"}`))
}

func testHealthCheckReturns200(t *testing.T) {
	req, err := http.NewRequest("GET", "/health", nil)
	if err != nil {
		t.Fatalf("Error creating request: %v", err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(healthCheckMock)

	handler.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Errorf("expected status %d, got %d", http.StatusOK, rr.Code)
	}
}
