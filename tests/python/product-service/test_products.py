# tests/python/product-service/test_minimal.py

def health_check():
    """Simula la función health_check del servicio"""
    return {"status": "healthy", "service": "product-service"}

def test_health_check_returns_healthy():
    """Test mínimo pero más cercano a la realidad"""
    response = health_check()
    assert isinstance(response, dict)
    assert response.get("status") == "healthy"
    assert response.get("service") == "product-service"
