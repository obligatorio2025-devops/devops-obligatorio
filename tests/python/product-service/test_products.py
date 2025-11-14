import asyncio
from main import health_check
from fastapi import Request
from starlette.responses import JSONResponse

# Creamos un mock mínimo de Request
class DummyRequest:
    pass

def test_health_check_returns_healthy():
    # Llamamos a la función directamente
    loop = asyncio.get_event_loop()
    response = loop.run_until_complete(health_check(DummyRequest()))
    
    assert isinstance(response, JSONResponse)
    assert response.status_code == 200
    assert response.body.decode() == '{"status":"healthy"}'
