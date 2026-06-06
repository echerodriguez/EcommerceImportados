using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EcommerceImportados.Controllers
{
    [Authorize]
    public class PagosController : Controller
    {
        private readonly ApplicationDbContext _context;

        public PagosController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Pagar(int pedidoId)
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

            if (pedido.Estado != EstadoPedido.PendientePago)
            {
                return BadRequest(
                    "El pedido ya fue pagado.");
            }

            return View(pedido);
        }


        [HttpPost]
        [Authorize]
        public async Task<IActionResult> ConfirmarPago(
            int pedidoId,
            string numeroTarjeta,
            string titular,
            string vencimiento,
            string cvv)
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var pedido = _context.Pedidos
                .FirstOrDefault(p =>
                    p.Id == pedidoId &&
                    p.UsuarioId == usuarioId);

            if (pedido == null)
            {
                return Json(new
                {
                    success = false,
                    mensaje = "Pedido no encontrado."
                });
            }

            if (pedido.Estado != EstadoPedido.PendientePago)
            {
                return Json(new
                {
                    success = false,
                    mensaje = "El pedido ya fue pagado."
                });
            }

            if (string.IsNullOrWhiteSpace(numeroTarjeta) ||
                string.IsNullOrWhiteSpace(titular) ||
                string.IsNullOrWhiteSpace(vencimiento) ||
                string.IsNullOrWhiteSpace(cvv))
            {
                return Json(new
                {
                    success = false,
                    mensaje = "Complete todos los datos de la tarjeta."
                });
            }

            pedido.Estado = EstadoPedido.Pagado;

            await _context.SaveChangesAsync();

            return Json(new
            {
                success = true,
                mensaje = "Pago realizado correctamente."
            });
        }


    }
}