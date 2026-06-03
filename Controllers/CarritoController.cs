using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace EcommerceImportados.Controllers
{
    public class CarritoController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CarritoController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            var detalles = _context.DetallesCarrito
                .Include(d => d.Producto)
                .ToList();

            return View(detalles);
        }


        public IActionResult Agregar(int productoId)
        {
            var producto = _context.Productos
                .FirstOrDefault(p => p.Id == productoId);

            if (producto == null)
            {
                return NotFound();
            }

            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var carrito = _context.Carritos
                .FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return NotFound("No se encontró un carrito para este usuario.");
            }

            int carritoId = carrito.Id;

            var detalleExistente = _context.DetallesCarrito
                .FirstOrDefault(d =>
                    d.CarritoId == carritoId &&
                    d.ProductoId == productoId);

            if (detalleExistente != null)
            {
                detalleExistente.Cantidad++;
                detalleExistente.PrecioUnitario =
                    producto.Precio * detalleExistente.Cantidad;
            }
            else
            {
                var detalle = new DetalleCarrito
                {
                    CarritoId = carritoId,
                    ProductoId = producto.Id,
                    Cantidad = 1,
                    PrecioUnitario = producto.Precio
                };

                _context.DetallesCarrito.Add(detalle);
            }

            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> FinalizarCompra()
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var carrito = _context.Carritos
                .FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return NotFound("No se encontró un carrito para este usuario.");
            }

            int carritoId = carrito.Id;

            var detalles = _context.DetallesCarrito
                .Include(d => d.Producto)
                .Where(d => d.CarritoId == carritoId)
                .ToList();

            if (!detalles.Any())
            {
                return RedirectToAction("Index");
            }

            var pedido = new Pedido
            {
                Fecha = DateTime.Now,
                Estado = EstadoPedido.PendientePago,
                UsuarioId = usuarioId,
                Activo = true
            };

            pedido.Total = detalles.Sum(d => d.PrecioUnitario);

            foreach (var detalle in detalles)
            {
                pedido.Detalles.Add(
                    new DetallePedido
                    {
                        ProductoId = detalle.ProductoId,
                        Cantidad = detalle.Cantidad,
                        PrecioUnitario = detalle.PrecioUnitario
                    });
            }

            _context.Pedidos.Add(pedido);

            _context.DetallesCarrito.RemoveRange(detalles);

            await _context.SaveChangesAsync();

            return RedirectToAction(
                "HistorialCompras",
                "Account");
        }
    }
}