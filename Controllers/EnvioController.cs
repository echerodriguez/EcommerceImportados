using Microsoft.AspNetCore.Mvc;
namespace EcommerceImportados.Controllers
{
    public class EnvioController : Controller
    {
        public IActionResult Index(int pedidoId)
        {
            ViewBag.PedidoId = pedidoId;
            return View();
        }

        [HttpPost]
        public IActionResult Continuar(int pedidoId)
        {
            return RedirectToAction(
                "Pagar",
                "Pagos",
                new { pedidoId });
        }
    }
}