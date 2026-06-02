using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace EcommerceImportados.Controllers
{
    public class HomeController : Controller
    {
        // 1. Declaramos el objeto privado del contexto
        private readonly ApplicationDbContext _context;

        // 2. Lo recibimos por el constructor mediante Inyección de Dependencias
        public HomeController(ApplicationDbContext context)
        {
            _context = context;
        }

        // 3. Modificamos el Index para que sea asíncrono y cargue los datos
        public async Task<IActionResult> Index()
        {
            // Cargamos las categorías para los filtros del panel lateral
            ViewBag.Categorias = await _context.Categorias.ToListAsync();

            // Cargamos los productos para la grilla principal
            var productos = await _context.Productos.ToListAsync();

            return View(productos);
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
