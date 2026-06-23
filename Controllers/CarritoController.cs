using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity.Data;
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
            if (User.Identity == null || !User.Identity.IsAuthenticated)
            {
                TempData["ErrorCarrito"] =
                    "Debe iniciar sesión para ver su carrito.";

                return RedirectToAction(
                    "Login",
                    "Account");
            }

            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);
            var carrito = _context.Carritos.
                FirstOrDefault(c => c.UsuarioId == usuarioId);

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
            if (User.Identity == null || !User.Identity.IsAuthenticated)
            {
                return Json(new
                {
                    success = false,
                    requiereLogin = true,
                    mensaje = "Debe iniciar sesión para agregar productos al carrito."
                });
            }

            var producto = _context.Productos
                .FirstOrDefault(p => p.Id == productoId);

            if (producto == null)
            {
                return Json(new
                {
                    success = false,
                    mensaje = "Producto no encontrado."
                });
            }

            int usuarioId = int.Parse(
                User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

            var carrito = _context.Carritos
                .FirstOrDefault(c => c.UsuarioId == usuarioId);

            if (carrito == null)
            {
                return Json(new
                {
                    success = false,
                    mensaje = "El usuario no tiene carrito asociado."
                });
            }

            var detalleExistente = _context.DetallesCarrito
                .FirstOrDefault(d =>
                    d.CarritoId == carrito.Id &&
                    d.ProductoId == productoId);

            if (detalleExistente != null)
            {
                if (detalleExistente.Cantidad + 1 > producto.Stock)
                {
                    return Json(new
                    {
                        success = false,
                        mensaje = "No hay stock suficiente."
                    });
                }

                detalleExistente.Cantidad++;
            }
            else
            {
                if (producto.Stock <= 0)
                {
                    return Json(new
                    {
                        success = false,
                        mensaje = "Producto sin stock."
                    });
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

            int cantidadTotal = _context.DetallesCarrito
                .Where(d => d.CarritoId == carrito.Id)
                .Sum(d => d.Cantidad);

            return Json(new
            {
                success = true,
                cantidad = cantidadTotal
            });
        }

        [Authorize]
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
                TempData["ErrorCarrito"] = "El carrito está vacío.";
                return RedirectToAction("Index");
            }

            foreach (var detalle in detalles)
            {
                if (detalle.Cantidad > detalle.Producto.Stock)
                {
                    TempData["ErrorCarrito"] =
                        $"No hay stock suficiente para {detalle.Producto.Nombre}";

                    return RedirectToAction("Index");
                }
            }

            var pedido = new Pedido
            {
                Fecha = DateTime.Now,
                Estado = EstadoPedido.PendienteDatosEnvio,
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
                "Index",
                "Envio",
                new { pedidoId = pedido.Id });
        }

        [Authorize]
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
                TempData["ErrorCarrito"] = "No hay stock suficiente.";
                return RedirectToAction("Index");
            }

            detalle.Cantidad++;

            _context.SaveChanges();

            return RedirectToAction("Index");
        }

        [Authorize]
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

        [Authorize]
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