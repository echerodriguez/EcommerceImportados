using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace EcommerceImportados.Controllers
{
    [Authorize]
    public class CarritoController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CarritoController(ApplicationDbContext context)
        {
            _context = context;
        }
        
        public IActionResult Index()
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var carrito = _context.Carritos.FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return View(new List<DetalleCarrito>());
            }

            var detalles = _context.DetallesCarrito
                .Include(d => d.Producto)
                .Where(d => d.CarritoId == carrito.Id)
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
                return BadRequest("El usuario no tiene carrito asociado.");
            }

            var detalleExistente = _context.DetallesCarrito
                .FirstOrDefault(d =>
                    d.CarritoId == carrito.Id &&
                    d.ProductoId == productoId);

            if (detalleExistente != null)
            {
                if (detalleExistente.Cantidad + 1 > producto.Stock)
                {
                    TempData["Error"] = "No hay stock suficiente.";
                    return RedirectToAction("Index");
                }

                detalleExistente.Cantidad++;
            }
            else
            {
                if (producto.Stock <= 0)
                {
                    TempData["Error"] = "Producto sin stock.";
                    return RedirectToAction("Index");
                }

                var detalle = new DetalleCarrito
                {
                    CarritoId = carrito.Id,
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
                return BadRequest("No existe carrito.");
            }

            var detalles = _context.DetallesCarrito
                .Include(d => d.Producto)
                .Where(d => d.CarritoId == carrito.Id)
                .ToList();

            if (!detalles.Any())
            {
                TempData["Error"] = "El carrito está vacío.";
                return RedirectToAction("Index");
            }

            foreach (var detalle in detalles)
            {
                if (detalle.Cantidad > detalle.Producto.Stock)
                {
                    TempData["Error"] =
                        $"No hay stock suficiente para {detalle.Producto.Nombre}";

                    return RedirectToAction("Index");
                }
            }

            var pedido = new Pedido
            {
                Fecha = DateTime.Now,
                Estado = EstadoPedido.PendientePago,
                UsuarioId = usuarioId,
                Activo = true
            };

            pedido.Total = detalles.Sum(d =>
                d.PrecioUnitario * d.Cantidad);

            foreach (var detalle in detalles)
            {
                pedido.Detalles.Add(
                    new DetallePedido
                    {
                        ProductoId = detalle.ProductoId,
                        Cantidad = detalle.Cantidad,
                        PrecioUnitario = detalle.PrecioUnitario
                    });

                detalle.Producto.Stock -= detalle.Cantidad;
            }

            _context.Pedidos.Add(pedido);

            _context.DetallesCarrito.RemoveRange(detalles);

            await _context.SaveChangesAsync();

            return RedirectToAction(
                "Pagar",
                "Pagos",
                new { pedidoId = pedido.Id });
        }

        [HttpPost]
        public IActionResult IncrementarCantidad(int productoId)
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var carrito = _context.Carritos
                .FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return BadRequest();
            }

            var detalle = _context.DetallesCarrito
                .Include(d => d.Producto)
                .FirstOrDefault(d =>
                    d.CarritoId == carrito.Id &&
                    d.ProductoId == productoId);

            if (detalle == null)
            {
                return NotFound();
            }

            if (detalle.Cantidad + 1 > detalle.Producto.Stock)
            {
                TempData["Error"] = "No hay stock suficiente.";
                return RedirectToAction("Index");
            }

            detalle.Cantidad++;

            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        [HttpPost]
        public IActionResult DisminuirCantidad(int productoId)
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var carrito = _context.Carritos
                .FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return BadRequest();
            }

            var detalle = _context.DetallesCarrito
                .FirstOrDefault(d =>
                    d.CarritoId == carrito.Id &&
                    d.ProductoId == productoId);

            if (detalle == null)
            {
                return NotFound();
            }

            detalle.Cantidad--;

            if (detalle.Cantidad <= 0)
            {
                _context.DetallesCarrito.Remove(detalle);
            }

            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        [HttpPost]
        public IActionResult EliminarProducto(int productoId)
        {
            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var carrito = _context.Carritos
                .FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return BadRequest();
            }

            var detalle = _context.DetallesCarrito
                .FirstOrDefault(d =>
                    d.CarritoId == carrito.Id &&
                    d.ProductoId == productoId);

            if (detalle == null)
            {
                return NotFound();
            }

            _context.DetallesCarrito.Remove(detalle);

            _context.SaveChanges();

            return RedirectToAction("Index");
        }
    }
}