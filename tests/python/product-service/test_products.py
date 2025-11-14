import sys
from pathlib import Path
import importlib.util
from fastapi.testclient import TestClient

# Ruta al archivo main.py dentro de app/product-service
ROOT = Path(__file__).resolve().parents[3]
MAIN_FILE = ROOT / "app" / "product-service" / "main.py"

# Cargar dinámicamente main.py como módulo
spec = importlib.util.spec_from_file_location("product_service", MAIN_FILE)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

app = module.app
client = TestClient(app)

def test_health_check():
    res = client.get("/health")
    assert res.status_code == 200
    assert res.json()["status"] == "healthy"
