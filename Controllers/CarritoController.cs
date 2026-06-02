using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

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

            int carritoId = 1;

            var detalleExistente = _context.DetallesCarrito
                .FirstOrDefault(d =>
                    d.CarritoId == carritoId &&
                    d.ProductoId == productoId);

            if (detalleExistente != null)
            {
                detalleExistente.Cantidad++;
                detalleExistente.PrecioUnitario = producto.Precio * detalleExistente.Cantidad;
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
    }
}