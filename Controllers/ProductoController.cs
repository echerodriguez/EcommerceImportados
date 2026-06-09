using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using EcommerceImportados.Data;
using EcommerceImportados.Models;

namespace EcommerceImportados.Controllers
{
    public class ProductoController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ProductoController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: /productos (vista del catálogo)
        [Route("productos")]
        public async Task<IActionResult> Index([FromQuery] List<int> categorias, [FromQuery] string orden)
        {
            IActionResult respuesta;
            ViewBag.Categorias = await _context.Categorias.ToListAsync();

            var query = _context.Productos.Include(p => p.Categoria).AsQueryable();

            if (categorias != null && categorias.Count > 0)
            {
                query = query.Where(p => categorias.Contains(p.CategoriaId));
            }

            if (orden == "menor_mayor")
            {
                query = query.OrderBy(p => p.Precio);
            }
            else if (orden == "mayor_menor")
            {
                query = query.OrderByDescending(p => p.Precio);
            }
            else
            {
                query = query.OrderByDescending(p => p.Id);
            }

            respuesta = View(await query.ToListAsync());

            return respuesta;
        }

        // GET: Producto/Admin (Panel de control del Administrador)
        public async Task<IActionResult> Admin()
        {
            var productos = await _context.Productos.Include(p => p.Categoria).ToListAsync();
            return View(productos);
        }

        // GET: Producto/Create
        public async Task<IActionResult> Create()
        {
            ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre");
            return View();
        }

        // POST: Producto/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Nombre,Descripcion,Precio,Stock,ImagenUrl,CategoriaId")] Producto producto)
        {
            producto.SKU = $"CAT{producto.CategoriaId}-{DateTime.Now.Ticks.ToString().Substring(10)}";

            ModelState.Remove("Categoria");
            ModelState.Remove("SKU");

            if (string.IsNullOrWhiteSpace(producto.ImagenUrl))
            {
                producto.ImagenUrl = null;
            }

            if (ModelState.IsValid)
            {
                _context.Add(producto);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Admin));
            }

            ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre", producto.CategoriaId);
            return View(producto);
        }

        // GET: Producto/Edit
        public async Task<IActionResult> Edit(int? id)
        {
            IActionResult respuesta = NotFound();
            if (id != null)
            {
                var producto = await _context.Productos.FindAsync(id);
                if (producto != null)
                {
                    ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre", producto.CategoriaId);
                    respuesta = View(producto);
                }
            }
            return respuesta;
        }

        // POST: Producto/Edit
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,Nombre,Descripcion,SKU,Precio,Stock,ImagenUrl,CategoriaId")] Producto producto)
        {
            IActionResult respuesta = View(producto);
            if (id == producto.Id)
            {
                if (ModelState.IsValid)
                {
                    _context.Update(producto);
                    await _context.SaveChangesAsync();
                    respuesta = RedirectToAction(nameof(Admin));
                }
                else
                {
                    ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre", producto.CategoriaId);
                }
            }
            else
            {
                respuesta = NotFound();
            }
            return respuesta;
        }

        // POST: Producto/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(int id)
        {
            var producto = await _context.Productos.FindAsync(id);
            if (producto != null)
            {
                _context.Productos.Remove(producto);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Admin));
        }
    }
}