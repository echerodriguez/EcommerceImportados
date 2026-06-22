using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EcommerceImportados.Controllers
{
    [Authorize]
    public class EnvioController : Controller
    {
        private readonly ApplicationDbContext _context;

        public EnvioController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index(int pedidoId)
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var pedido = _context.Pedidos
                .FirstOrDefault(p =>
                    p.Id == pedidoId &&
                    p.UsuarioId == usuarioId);

            if (pedido == null)
            {
                return RedirectToAction(
                "Home",
                "Index");
            }

            if (pedido.Estado == EstadoPedido.PendientePago)
            {
                return RedirectToAction(
                    "Pagar",
                    "Pagos",
                    new { pedidoId = pedido.Id });
            }

            if (pedido.Estado != EstadoPedido.PendienteDatosEnvio)
            {
                return BadRequest(
                    "El pedido no está pendiente de datos de envío.");
            }

            return View(pedido);
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmarEnvio(
            int pedidoId,
            string nombreCompleto,
            string telefono,
            string provincia,
            string localidad,
            string direccion,
            string codigoPostal,
            string? observaciones)
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var pedido = _context.Pedidos
                .FirstOrDefault(p =>
                    p.Id == pedidoId &&
                    p.UsuarioId == usuarioId);

            if (pedido == null)
            {
                return NotFound();
            }

            if (pedido.Estado != EstadoPedido.PendienteDatosEnvio)
            {
                return BadRequest(
                    "El pedido no está pendiente de datos de envío.");
            }

            if (string.IsNullOrWhiteSpace(nombreCompleto) ||
                string.IsNullOrWhiteSpace(telefono) ||
                string.IsNullOrWhiteSpace(provincia) ||
                string.IsNullOrWhiteSpace(localidad) ||
                string.IsNullOrWhiteSpace(direccion) ||
                string.IsNullOrWhiteSpace(codigoPostal))
            {
                TempData["ErrorEnvio"] =
                    "Complete todos los datos obligatorios de envío.";

                return RedirectToAction(
                    "Index",
                    new { pedidoId = pedido.Id });
            }

            pedido.Estado = EstadoPedido.PendientePago;

            await _context.SaveChangesAsync();

            return RedirectToAction(
                "Pagar",
                "Pagos",
                new { pedidoId = pedido.Id });
        }
    }
}