[1mdiff --git a/Controllers/AccountController.cs b/Controllers/AccountController.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..1fffd58[m
[1m--- /dev/null[m
[1m+++ b/Controllers/AccountController.cs[m
[36m@@ -0,0 +1,147 @@[m
[32m+[m[32m﻿using EcommerceImportados.Data;[m
[32m+[m[32musing EcommerceImportados.Models;[m
[32m+[m[32musing EcommerceImportados.ViewModels;[m
[32m+[m[32musing Microsoft.AspNetCore.Mvc;[m
[32m+[m[32musing Microsoft.AspNetCore.Authorization;[m
[32m+[m[32musing Microsoft.AspNetCore.Authentication;[m
[32m+[m[32musing Microsoft.AspNetCore.Authentication.Cookies;[m
[32m+[m[32musing System.Security.Claims;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore;[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Controllers;[m
[32m+[m
[32m+[m[32mpublic class AccountController : Controller[m
[32m+[m[32m{[m
[32m+[m[32m    private readonly ApplicationDbContext _context;[m
[32m+[m
[32m+[m[32m    public AccountController(ApplicationDbContext context)[m
[32m+[m[32m    {[m
[32m+[m[32m        _context = context;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [HttpGet][m
[32m+[m[32m    public IActionResult Login()[m
[32m+[m[32m    {[m
[32m+[m[32m        return View(new LoginViewModel());[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [HttpPost][m
[32m+[m[32m    public async Task<IActionResult> Login(LoginViewModel model)[m
[32m+[m[32m    {[m
[32m+[m[32m        if (!ModelState.IsValid)[m
[32m+[m[32m            return View(model);[m
[32m+[m
[32m+[m[32m        Usuario? usuario = _context.Usuarios[m
[32m+[m[32m            .FirstOrDefault(u =>[m
[32m+[m[32m                u.Email == model.Email &&[m
[32m+[m[32m                u.Password == model.Password);[m
[32m+[m
[32m+[m[32m        if (usuario == null)[m
[32m+[m[32m        {[m
[32m+[m[32m            ModelState.AddModelError("",[m
[32m+[m[32m                "Email o contraseña incorrectos");[m
[32m+[m
[32m+[m[32m            return View(model);[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        var claims = new List<Claim>[m
[32m+[m[32m    {[m
[32m+[m[32m        new Claim(ClaimTypes.NameIdentifier,[m
[32m+[m[32m                  usuario.Id.ToString()),[m
[32m+[m
[32m+[m[32m        new Claim(ClaimTypes.Name,[m
[32m+[m[32m                  usuario.Nombre),[m
[32m+[m
[32m+[m[32m        new Claim(ClaimTypes.Email,[m
[32m+[m[32m                  usuario.Email),[m
[32m+[m
[32m+[m[32m        new Claim(ClaimTypes.Role,[m
[32m+[m[32m                  usuario.Rol.ToString())[m
[32m+[m[32m    };[m
[32m+[m
[32m+[m[32m        var identity = new ClaimsIdentity([m
[32m+[m[32m            claims,[m
[32m+[m[32m            CookieAuthenticationDefaults.AuthenticationScheme);[m
[32m+[m
[32m+[m[32m        var principal = new ClaimsPrincipal(identity);[m
[32m+[m
[32m+[m[32m        await HttpContext.SignInAsync([m
[32m+[m[32m            CookieAuthenticationDefaults.AuthenticationScheme,[m
[32m+[m[32m            principal);[m
[32m+[m
[32m+[m[32m        return RedirectToAction("Index", "Home");[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [HttpGet][m
[32m+[m[32m    public IActionResult Register()[m
[32m+[m[32m    {[m
[32m+[m[32m        return View(new RegisterViewModel());[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [HttpPost][m
[32m+[m[32m    public async Task<IActionResult> Register(RegisterViewModel model)[m
[32m+[m[32m    {[m
[32m+[m[32m        if (!ModelState.IsValid)[m
[32m+[m[32m            return View(model);[m
[32m+[m
[32m+[m[32m        bool emailExiste = _context.Usuarios[m
[32m+[m[32m            .Any(u => u.Email == model.Email);[m
[32m+[m
[32m+[m[32m        if (emailExiste)[m
[32m+[m[32m        {[m
[32m+[m[32m            ModelState.AddModelError("Email",[m
[32m+[m[32m                "Ya existe un usuario con ese email.");[m
[32m+[m
[32m+[m[32m            return View(model);[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        Usuario usuario = new Usuario[m
[32m+[m[32m        {[m
[32m+[m[32m            Nombre = model.Nombre,[m
[32m+[m[32m            Apellido = model.Apellido,[m
[32m+[m[32m            Email = model.Email,[m
[32m+[m[32m            DNI = model.DNI,[m
[32m+[m[32m            Password = model.Password[m
[32m+[m[32m        };[m
[32m+[m
[32m+[m[32m        _context.Usuarios.Add(usuario);[m
[32m+[m
[32m+[m[32m        await _context.SaveChangesAsync();[m
[32m+[m
[32m+[m[32m        return RedirectToAction("Login");[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    public async Task<IActionResult> Logout()[m
[32m+[m[32m    {[m
[32m+[m[32m        await HttpContext.SignOutAsync([m
[32m+[m[32m            CookieAuthenticationDefaults.AuthenticationScheme);[m
[32m+[m
[32m+[m[32m        return RedirectToAction("Login");[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [Authorize(Roles = "RolAdministrador")][m
[32m+[m[32m    public IActionResult TestAdmin()[m
[32m+[m[32m    {[m
[32m+[m[32m        return Content("Sos administrador");[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [Authorize][m
[32m+[m[32m    public IActionResult TestUsuario()[m
[32m+[m[32m    {[m
[32m+[m[32m        return Content("Estás logueado");[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [Authorize][m
[32m+[m[32m    public IActionResult HistorialCompras()[m
[32m+[m[32m    {[m
[32m+[m[32m        int usuarioId = int.Parse([m
[32m+[m[32m            User.FindFirst(ClaimTypes.NameIdentifier)!.Value);[m
[32m+[m
[32m+[m[32m        var pedidos = _context.Pedidos[m
[32m+[m[32m            .Where(p => p.UsuarioId == usuarioId)[m
[32m+[m[32m            .OrderByDescending(p => p.Fecha)[m
[32m+[m[32m            .ToList();[m
[32m+[m
[32m+[m[32m        return View(pedidos);[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/Controllers/CarritoController.cs b/Controllers/CarritoController.cs[m
[1mdeleted file mode 100644[m
[1mindex c787b89..0000000[m
[1m--- a/Controllers/CarritoController.cs[m
[1m+++ /dev/null[m
[36m@@ -1,66 +0,0 @@[m
[31m-﻿using EcommerceImportados.Data;[m
[31m-using EcommerceImportados.Models;[m
[31m-using Microsoft.AspNetCore.Mvc;[m
[31m-using Microsoft.EntityFrameworkCore;[m
[31m-[m
[31m-namespace EcommerceImportados.Controllers[m
[31m-{[m
[31m-    public class CarritoController : Controller[m
[31m-    {[m
[31m-        private readonly ApplicationDbContext _context;[m
[31m-[m
[31m-        public CarritoController(ApplicationDbContext context)[m
[31m-        {[m
[31m-            _context = context;[m
[31m-        }[m
[31m-[m
[31m-        public IActionResult Index()[m
[31m-        {[m
[31m-            var detalles = _context.DetallesCarrito[m
[31m-                .Include(d => d.Producto)[m
[31m-                .ToList();[m
[31m-[m
[31m-            return View(detalles);[m
[31m-        }[m
[31m-[m
[31m-        public IActionResult Agregar(int productoId)[m
[31m-        {[m
[31m-            var producto = _context.Productos[m
[31m-                .FirstOrDefault(p => p.Id == productoId);[m
[31m-[m
[31m-            if (producto == null)[m
[31m-            {[m
[31m-                return NotFound();[m
[31m-            }[m
[31m-[m
[31m-            int carritoId = 1;[m
[31m-[m
[31m-            var detalleExistente = _context.DetallesCarrito[m
[31m-                .FirstOrDefault(d =>[m
[31m-                    d.CarritoId == carritoId &&[m
[31m-                    d.ProductoId == productoId);[m
[31m-[m
[31m-            if (detalleExistente != null)[m
[31m-            {[m
[31m-                detalleExistente.Cantidad++;[m
[31m-                detalleExistente.PrecioUnitario = producto.Precio * detalleExistente.Cantidad;[m
[31m-            }[m
[31m-            else[m
[31m-            {[m
[31m-                var detalle = new DetalleCarrito[m
[31m-                {[m
[31m-                    CarritoId = carritoId,[m
[31m-                    ProductoId = producto.Id,[m
[31m-                    Cantidad = 1,[m
[31m-                    PrecioUnitario = producto.Precio[m
[31m-                };[m
[31m-[m
[31m-                _context.DetallesCarrito.Add(detalle);[m
[31m-            }[m
[31m-[m
[31m-            _context.SaveChanges();[m
[31m-[m
[31m-            return RedirectToAction("Index");[m
[31m-        }[m
[31m-    }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/Controllers/CategoriasController.cs b/Controllers/CategoriasController.cs[m
[1mdeleted file mode 100644[m
[1mindex e4977dc..0000000[m
[1m--- a/Controllers/CategoriasController.cs[m
[1m+++ /dev/null[m
[36m@@ -1,66 +0,0 @@[m
[31m-﻿using Microsoft.AspNetCore.Mvc;[m
[31m-using Microsoft.EntityFrameworkCore;[m
[31m-using EcommerceImportados.Data;[m
[31m-using EcommerceImportados.Models;[m
[31m-[m
[31m-namespace EcommerceImportados.Controllers[m
[31m-{[m
[31m-    public class CategoriasController : Controller[m
[31m-    {[m
[31m-        private readonly ApplicationDbContext _context;[m
[31m-[m
[31m-        public CategoriasController(ApplicationDbContext context)[m
[31m-        {[m
[31m-            _context = context;[m
[31m-        }[m
[31m-[m
[31m-        // GET: Categorias (Panel CRUD Unificado)[m
[31m-        public async Task<IActionResult> Index()[m
[31m-        {[m
[31m-            var categorias = await _context.Categorias.ToListAsync();[m
[31m-            return View(categorias);[m
[31m-        }[m
[31m-[m
[31m-        // POST: Categorias/Create[m
[31m-        [HttpPost][m
[31m-        [ValidateAntiForgeryToken][m
[31m-        public async Task<IActionResult> Create([Bind("Nombre")] Categoria categoria)[m
[31m-        {[m
[31m-            if (ModelState.IsValid)[m
[31m-            {[m
[31m-                _context.Add(categoria);[m
[31m-                await _context.SaveChangesAsync();[m
[31m-            }[m
[31m-            return RedirectToAction(nameof(Index));[m
[31m-        }[m
[31m-[m
[31m-        // POST: Categorias/Edit[m
[31m-        [HttpPost][m
[31m-        [ValidateAntiForgeryToken][m
[31m-        public async Task<IActionResult> Edit(int id, [Bind("Id,Nombre")] Categoria categoria)[m
[31m-        {[m
[31m-            if (id != categoria.Id) return NotFound();[m
[31m-[m
[31m-            if (ModelState.IsValid)[m
[31m-            {[m
[31m-                _context.Update(categoria);[m
[31m-                await _context.SaveChangesAsync();[m
[31m-            }[m
[31m-            return RedirectToAction(nameof(Index));[m
[31m-        }[m
[31m-[m
[31m-        // POST: Categorias/Delete[m
[31m-        [HttpPost][m
[31m-        [ValidateAntiForgeryToken][m
[31m-        public async Task<IActionResult> Delete(int id)[m
[31m-        {[m
[31m-            var categoria = await _context.Categorias.FindAsync(id);[m
[31m-            if (categoria != null)[m
[31m-            {[m
[31m-                _context.Categorias.Remove(categoria);[m
[31m-                await _context.SaveChangesAsync();[m
[31m-            }[m
[31m-            return RedirectToAction(nameof(Index));[m
[31m-        }[m
[31m-    }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/Controllers/HomeController.cs b/Controllers/HomeController.cs[m
[1mindex 459e716..8764ad2 100644[m
[1m--- a/Controllers/HomeController.cs[m
[1m+++ b/Controllers/HomeController.cs[m
[36m@@ -1,32 +1,14 @@[m
[31m-using EcommerceImportados.Data;[m
 using EcommerceImportados.Models;[m
 using Microsoft.AspNetCore.Mvc;[m
[31m-using Microsoft.EntityFrameworkCore;[m
 using System.Diagnostics;[m
 [m
 namespace EcommerceImportados.Controllers[m
 {[m
     public class HomeController : Controller[m
     {[m
[31m-        // 1. Declaramos el objeto privado del contexto[m
[31m-        private readonly ApplicationDbContext _context;[m
[31m-[m
[31m-        // 2. Lo recibimos por el constructor mediante Inyección de Dependencias[m
[31m-        public HomeController(ApplicationDbContext context)[m
[31m-        {[m
[31m-            _context = context;[m
[31m-        }[m
[31m-[m
[31m-        // 3. Modificamos el Index para que sea asíncrono y cargue los datos[m
[31m-        public async Task<IActionResult> Index()[m
[32m+[m[32m        public IActionResult Index()[m
         {[m
[31m-            // Cargamos las categorías para los filtros del panel lateral[m
[31m-            ViewBag.Categorias = await _context.Categorias.ToListAsync();[m
[31m-[m
[31m-            // Cargamos los productos para la grilla principal[m
[31m-            var productos = await _context.Productos.ToListAsync();[m
[31m-[m
[31m-            return View(productos);[m
[32m+[m[32m            return View();[m
         }[m
 [m
         public IActionResult Privacy()[m
[1mdiff --git a/Controllers/PedidoController.cs b/Controllers/PedidoController.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..868136c[m
[1m--- /dev/null[m
[1m+++ b/Controllers/PedidoController.cs[m
[36m@@ -0,0 +1,36 @@[m
[32m+[m[32m﻿using EcommerceImportados.Data;[m
[32m+[m[32musing EcommerceImportados.Models;[m
[32m+[m[32musing Microsoft.AspNetCore.Authorization;[m
[32m+[m[32musing Microsoft.AspNetCore.Mvc;[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Controllers;[m
[32m+[m
[32m+[m[32m[Authorize][m
[32m+[m[32mpublic class PedidoController : Controller[m
[32m+[m[32m{[m
[32m+[m[32m    private readonly ApplicationDbContext _context;[m
[32m+[m
[32m+[m[32m    public PedidoController(ApplicationDbContext context)[m
[32m+[m[32m    {[m
[32m+[m[32m        _context = context;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    [Authorize(Roles = "RolAdministrador")][m
[32m+[m[32m    public async Task<IActionResult> CambiarEstado([m
[32m+[m[32m        int id,[m
[32m+[m[32m        EstadoPedido nuevoEstado)[m
[32m+[m[32m    {[m
[32m+[m[32m        var pedido = await _context.Pedidos.FindAsync(id);[m
[32m+[m
[32m+[m[32m        if (pedido == null)[m
[32m+[m[32m            return NotFound();[m
[32m+[m
[32m+[m[32m        pedido.Estado = nuevoEstado;[m
[32m+[m
[32m+[m[32m        await _context.SaveChangesAsync();[m
[32m+[m
[32m+[m[32m        return RedirectToAction("Index");[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m
[32m+[m[32m}[m
[1mdiff --git a/Controllers/ProductoController.cs b/Controllers/ProductoController.cs[m
[1mdeleted file mode 100644[m
[1mindex 38802c3..0000000[m
[1m--- a/Controllers/ProductoController.cs[m
[1m+++ /dev/null[m
[36m@@ -1,123 +0,0 @@[m
[31m-﻿using Microsoft.AspNetCore.Mvc;[m
[31m-using Microsoft.AspNetCore.Mvc.Rendering;[m
[31m-using Microsoft.EntityFrameworkCore;[m
[31m-using EcommerceImportados.Data;[m
[31m-using EcommerceImportados.Models;[m
[31m-[m
[31m-namespace EcommerceImportados.Controllers[m
[31m-{[m
[31m-    public class ProductoController : Controller[m
[31m-    {[m
[31m-        private readonly ApplicationDbContext _context;[m
[31m-[m
[31m-        public ProductoController(ApplicationDbContext context)[m
[31m-        {[m
[31m-            _context = context;[m
[31m-        }[m
[31m-[m
[31m-        // GET: /productos (Vista pública del catálogo)[m
[31m-        [Route("productos")][m
[31m-        public async Task<IActionResult> Index()[m
[31m-        {[m
[31m-            ViewBag.Categorias = await _context.Categorias.ToListAsync();[m
[31m-            var productos = await _context.Productos.Include(p => p.Categoria).ToListAsync();[m
[31m-            return View(productos);[m
[31m-        }[m
[31m-[m
[31m-        // GET: Producto/Admin (Panel de control del Administrador)[m
[31m-        public async Task<IActionResult> Admin()[m
[31m-        {[m
[31m-            var productos = await _context.Productos.Include(p => p.Categoria).ToListAsync();[m
[31m-            return View(productos);[m
[31m-        }[m
[31m-[m
[31m-        // GET: Producto/Create[m
[31m-        public async Task<IActionResult> Create()[m
[31m-        {[m
[31m-            ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre");[m
[31m-            return View();[m
[31m-        }[m
[31m-[m
[31m-        // POST: Producto/Create[m
[31m-        [HttpPost][m
[31m-        [ValidateAntiForgeryToken][m
[31m-        public async Task<IActionResult> Create([Bind("Nombre,Descripcion,Precio,Stock,ImagenUrl,CategoriaId")] Producto producto)[m
[31m-        {[m
[31m-            producto.SKU = $"CAT{producto.CategoriaId}-{DateTime.Now.Ticks.ToString().Substring(10)}";[m
[31m-[m
[31m-            ModelState.Remove("Categoria");[m
[31m-            ModelState.Remove("SKU");[m
[31m-[m
[31m-            if (string.IsNullOrWhiteSpace(producto.ImagenUrl))[m
[31m-            {[m
[31m-                producto.ImagenUrl = null;[m
[31m-            }[m
[31m-[m
[31m-            if (ModelState.IsValid)[m
[31m-            {[m
[31m-                _context.Add(producto);[m
[31m-                await _context.SaveChangesAsync();[m
[31m-                return RedirectToAction(nameof(Admin));[m
[31m-            }[m
[31m-[m
[31m-            ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre", producto.CategoriaId);[m
[31m-            return View(producto);[m
[31m-        }[m
[31m-[m
[31m-        // GET: Producto/Edit[m
[31m-        public async Task<IActionResult> Edit(int? id)[m
[31m-        {[m
[31m-            IActionResult respuesta = NotFound();[m
[31m-            if (id != null)[m
[31m-            {[m
[31m-                var producto = await _context.Productos.FindAsync(id);[m
[31m-                if (producto != null)[m
[31m-                {[m
[31m-                    ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre", producto.CategoriaId);[m
[31m-                    respuesta = View(producto);[m
[31m-                }[m
[31m-            }[m
[31m-            return respuesta;[m
[31m-        }[m
[31m-[m
[31m-        // POST: Producto/Edit[m
[31m-        [HttpPost][m
[31m-        [ValidateAntiForgeryToken][m
[31m-        public async Task<IActionResult> Edit(int id, [Bind("Id,Nombre,Descripcion,SKU,Precio,Stock,ImagenUrl,CategoriaId")] Producto producto)[m
[31m-        {[m
[31m-            IActionResult respuesta = View(producto);[m
[31m-            if (id == producto.Id)[m
[31m-            {[m
[31m-                if (ModelState.IsValid)[m
[31m-                {[m
[31m-                    _context.Update(producto);[m
[31m-                    await _context.SaveChangesAsync();[m
[31m-                    respuesta = RedirectToAction(nameof(Admin));[m
[31m-                }[m
[31m-                else[m
[31m-                {[m
[31m-                    ViewBag.CategoriaId = new SelectList(await _context.Categorias.ToListAsync(), "Id", "Nombre", producto.CategoriaId);[m
[31m-                }[m
[31m-            }[m
[31m-            else[m
[31m-            {[m
[31m-                respuesta = NotFound();[m
[31m-            }[m
[31m-            return respuesta;[m
[31m-        }[m
[31m-[m
[31m-        // POST: Producto/Delete/5[m
[31m-        [HttpPost][m
[31m-        [ValidateAntiForgeryToken][m
[31m-        public async Task<IActionResult> Delete(int id)[m
[31m-        {[m
[31m-            var producto = await _context.Productos.FindAsync(id);[m
[31m-            if (producto != null)[m
[31m-            {[m
[31m-                _context.Productos.Remove(producto);[m
[31m-                await _context.SaveChangesAsync();[m
[31m-            }[m
[31m-            return RedirectToAction(nameof(Admin));[m
[31m-        }[m
[31m-    }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/Data/applicationDbContext.cs b/Data/applicationDbContext.cs[m
[1mindex c8fba41..8f7c7c5 100644[m
[1m--- a/Data/applicationDbContext.cs[m
[1m+++ b/Data/applicationDbContext.cs[m
[36m@@ -1,5 +1,4 @@[m
[31m-﻿using EcommerceImportados.Controllers;[m
[31m-using EcommerceImportados.Models;[m
[32m+[m[32m﻿using EcommerceImportados.Models;[m
 using Microsoft.EntityFrameworkCore;[m
 [m
 namespace EcommerceImportados.Data[m
[1mdiff --git a/EcommerceImportados.csproj b/EcommerceImportados.csproj[m
[1mindex 89e30fe..49fcada 100644[m
[1m--- a/EcommerceImportados.csproj[m
[1m+++ b/EcommerceImportados.csproj[m
[36m@@ -1,4 +1,4 @@[m
[31m-<Project Sdk="Microsoft.NET.Sdk.Web">[m
[32m+[m[32m﻿<Project Sdk="Microsoft.NET.Sdk.Web">[m
 [m
   <PropertyGroup>[m
     <TargetFramework>net9.0</TargetFramework>[m
[36m@@ -16,8 +16,4 @@[m
     </PackageReference>[m
   </ItemGroup>[m
 [m
[31m-  <ItemGroup>[m
[31m-    <Folder Include="Migrations\" />[m
[31m-  </ItemGroup>[m
[31m-[m
 </Project>[m
[1mdiff --git a/Migrations/20260601114055_CreateDBEcommerce.Designer.cs b/Migrations/20260601114055_CreateDBEcommerce.Designer.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..b6e7fd7[m
[1m--- /dev/null[m
[1m+++ b/Migrations/20260601114055_CreateDBEcommerce.Designer.cs[m
[36m@@ -0,0 +1,336 @@[m
[32m+[m[32m﻿// <auto-generated />[m
[32m+[m[32musing System;[m
[32m+[m[32musing EcommerceImportados.Data;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Infrastructure;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Metadata;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Migrations;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Storage.ValueConversion;[m
[32m+[m
[32m+[m[32m#nullable disable[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Migrations[m
[32m+[m[32m{[m
[32m+[m[32m    [DbContext(typeof(ApplicationDbContext))][m
[32m+[m[32m    [Migration("20260601114055_CreateDBEcommerce")][m
[32m+[m[32m    partial class CreateDBEcommerce[m
[32m+[m[32m    {[m
[32m+[m[32m        /// <inheritdoc />[m
[32m+[m[32m        protected override void BuildTargetModel(ModelBuilder modelBuilder)[m
[32m+[m[32m        {[m
[32m+[m[32m#pragma warning disable 612, 618[m
[32m+[m[32m            modelBuilder[m
[32m+[m[32m                .HasAnnotation("ProductVersion", "9.0.8")[m
[32m+[m[32m                .HasAnnotation("Relational:MaxIdentifierLength", 128);[m
[32m+[m
[32m+[m[32m            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("UsuarioId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("UsuarioId")[m
[32m+[m[32m                        .IsUnique();[m
[32m+[m
[32m+[m[32m                    b.ToTable("Carritos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Categoria", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(20)[m
[32m+[m[32m                        .HasColumnType("nvarchar(20)");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Categorias");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetalleCarrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Cantidad")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("CarritoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("PrecioUnitario")[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("ProductoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("CarritoId");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("ProductoId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("DetallesCarrito");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetallePedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Cantidad")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("PedidoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("PrecioUnitario")[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("ProductoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("PedidoId");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("ProductoId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("DetallesPedido");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<bool>("Activo")[m
[32m+[m[32m                        .HasColumnType("bit");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Estado")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<DateTime>("Fecha")[m
[32m+[m[32m                        .HasColumnType("datetime2");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("Total")[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("UsuarioId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("UsuarioId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Pedidos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("CategoriaId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Descripcion")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(500)[m
[32m+[m[32m                        .HasColumnType("nvarchar(500)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("ImagenUrl")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(100)[m
[32m+[m[32m                        .HasColumnType("nvarchar(100)");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("Precio")[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("SKU")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Stock")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("CategoriaId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Productos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Usuario", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Apellido")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(25)[m
[32m+[m[32m                        .HasColumnType("nvarchar(25)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("DNI")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Email")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(20)[m
[32m+[m[32m                        .HasColumnType("nvarchar(20)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Password")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Rol")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Usuarios");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Usuario", "Usuario")[m
[32m+[m[32m                        .WithOne("Carrito")[m
[32m+[m[32m                        .HasForeignKey("EcommerceImportados.Models.Carrito", "UsuarioId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Usuario");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetalleCarrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Carrito", "Carrito")[m
[32m+[m[32m                        .WithMany("Detalles")[m
[32m+[m[32m                        .HasForeignKey("CarritoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Producto", "Producto")[m
[32m+[m[32m                        .WithMany("DetallesCarrito")[m
[32m+[m[32m                        .HasForeignKey("ProductoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Carrito");[m
[32m+[m
[32m+[m[32m                    b.Navigation("Producto");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetallePedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Pedido", "Pedido")[m
[32m+[m[32m                        .WithMany("Detalles")[m
[32m+[m[32m                        .HasForeignKey("PedidoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Producto", "Producto")[m
[32m+[m[32m                        .WithMany("DetallesPedido")[m
[32m+[m[32m                        .HasForeignKey("ProductoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Pedido");[m
[32m+[m
[32m+[m[32m                    b.Navigation("Producto");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Usuario", "Usuario")[m
[32m+[m[32m                        .WithMany("Pedidos")[m
[32m+[m[32m                        .HasForeignKey("UsuarioId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Usuario");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Categoria", "Categoria")[m
[32m+[m[32m                        .WithMany("Productos")[m
[32m+[m[32m                        .HasForeignKey("CategoriaId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Categoria");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Detalles");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Categoria", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Productos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Detalles");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("DetallesCarrito");[m
[32m+[m
[32m+[m[32m                    b.Navigation("DetallesPedido");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Usuario", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Carrito")[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Pedidos");[m
[32m+[m[32m                });[m
[32m+[m[32m#pragma warning restore 612, 618[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/Migrations/20260601114055_CreateDBEcommerce.cs b/Migrations/20260601114055_CreateDBEcommerce.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..287f066[m
[1m--- /dev/null[m
[1m+++ b/Migrations/20260601114055_CreateDBEcommerce.cs[m
[36m@@ -0,0 +1,230 @@[m
[32m+[m[32m﻿using System;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Migrations;[m
[32m+[m
[32m+[m[32m#nullable disable[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Migrations[m
[32m+[m[32m{[m
[32m+[m[32m    /// <inheritdoc />[m
[32m+[m[32m    public partial class CreateDBEcommerce : Migration[m
[32m+[m[32m    {[m
[32m+[m[32m        /// <inheritdoc />[m
[32m+[m[32m        protected override void Up(MigrationBuilder migrationBuilder)[m
[32m+[m[32m        {[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "Categorias",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    Nombre = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_Categorias", x => x.Id);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "Usuarios",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    Nombre = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),[m
[32m+[m[32m                    Apellido = table.Column<string>(type: "nvarchar(25)", maxLength: 25, nullable: false),[m
[32m+[m[32m                    Email = table.Column<string>(type: "nvarchar(max)", nullable: false),[m
[32m+[m[32m                    DNI = table.Column<string>(type: "nvarchar(max)", nullable: false),[m
[32m+[m[32m                    Password = table.Column<string>(type: "nvarchar(max)", nullable: false),[m
[32m+[m[32m                    Rol = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_Usuarios", x => x.Id);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "Productos",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    Nombre = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),[m
[32m+[m[32m                    Descripcion = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: false),[m
[32m+[m[32m                    SKU = table.Column<string>(type: "nvarchar(max)", nullable: false),[m
[32m+[m[32m                    Precio = table.Column<decimal>(type: "decimal(18,2)", nullable: false),[m
[32m+[m[32m                    Stock = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    ImagenUrl = table.Column<string>(type: "nvarchar(max)", nullable: false),[m
[32m+[m[32m                    CategoriaId = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_Productos", x => x.Id);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_Productos_Categorias_CategoriaId",[m
[32m+[m[32m                        column: x => x.CategoriaId,[m
[32m+[m[32m                        principalTable: "Categorias",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "Carritos",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    UsuarioId = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_Carritos", x => x.Id);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_Carritos_Usuarios_UsuarioId",[m
[32m+[m[32m                        column: x => x.UsuarioId,[m
[32m+[m[32m                        principalTable: "Usuarios",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "Pedidos",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    Fecha = table.Column<DateTime>(type: "datetime2", nullable: false),[m
[32m+[m[32m                    Total = table.Column<decimal>(type: "decimal(18,2)", nullable: false),[m
[32m+[m[32m                    Estado = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    UsuarioId = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    Activo = table.Column<bool>(type: "bit", nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_Pedidos", x => x.Id);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_Pedidos_Usuarios_UsuarioId",[m
[32m+[m[32m                        column: x => x.UsuarioId,[m
[32m+[m[32m                        principalTable: "Usuarios",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "DetallesCarrito",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    CarritoId = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    ProductoId = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    Cantidad = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    PrecioUnitario = table.Column<decimal>(type: "decimal(18,2)", nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_DetallesCarrito", x => x.Id);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_DetallesCarrito_Carritos_CarritoId",[m
[32m+[m[32m                        column: x => x.CarritoId,[m
[32m+[m[32m                        principalTable: "Carritos",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_DetallesCarrito_Productos_ProductoId",[m
[32m+[m[32m                        column: x => x.ProductoId,[m
[32m+[m[32m                        principalTable: "Productos",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateTable([m
[32m+[m[32m                name: "DetallesPedido",[m
[32m+[m[32m                columns: table => new[m
[32m+[m[32m                {[m
[32m+[m[32m                    Id = table.Column<int>(type: "int", nullable: false)[m
[32m+[m[32m                        .Annotation("SqlServer:Identity", "1, 1"),[m
[32m+[m[32m                    PedidoId = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    ProductoId = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    Cantidad = table.Column<int>(type: "int", nullable: false),[m
[32m+[m[32m                    PrecioUnitario = table.Column<decimal>(type: "decimal(18,2)", nullable: false)[m
[32m+[m[32m                },[m
[32m+[m[32m                constraints: table =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    table.PrimaryKey("PK_DetallesPedido", x => x.Id);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_DetallesPedido_Pedidos_PedidoId",[m
[32m+[m[32m                        column: x => x.PedidoId,[m
[32m+[m[32m                        principalTable: "Pedidos",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                    table.ForeignKey([m
[32m+[m[32m                        name: "FK_DetallesPedido_Productos_ProductoId",[m
[32m+[m[32m                        column: x => x.ProductoId,[m
[32m+[m[32m                        principalTable: "Productos",[m
[32m+[m[32m                        principalColumn: "Id",[m
[32m+[m[32m                        onDelete: ReferentialAction.Cascade);[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_Carritos_UsuarioId",[m
[32m+[m[32m                table: "Carritos",[m
[32m+[m[32m                column: "UsuarioId",[m
[32m+[m[32m                unique: true);[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_DetallesCarrito_CarritoId",[m
[32m+[m[32m                table: "DetallesCarrito",[m
[32m+[m[32m                column: "CarritoId");[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_DetallesCarrito_ProductoId",[m
[32m+[m[32m                table: "DetallesCarrito",[m
[32m+[m[32m                column: "ProductoId");[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_DetallesPedido_PedidoId",[m
[32m+[m[32m                table: "DetallesPedido",[m
[32m+[m[32m                column: "PedidoId");[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_DetallesPedido_ProductoId",[m
[32m+[m[32m                table: "DetallesPedido",[m
[32m+[m[32m                column: "ProductoId");[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_Pedidos_UsuarioId",[m
[32m+[m[32m                table: "Pedidos",[m
[32m+[m[32m                column: "UsuarioId");[m
[32m+[m
[32m+[m[32m            migrationBuilder.CreateIndex([m
[32m+[m[32m                name: "IX_Productos_CategoriaId",[m
[32m+[m[32m                table: "Productos",[m
[32m+[m[32m                column: "CategoriaId");[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        /// <inheritdoc />[m
[32m+[m[32m        protected override void Down(MigrationBuilder migrationBuilder)[m
[32m+[m[32m        {[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "DetallesCarrito");[m
[32m+[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "DetallesPedido");[m
[32m+[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "Carritos");[m
[32m+[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "Pedidos");[m
[32m+[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "Productos");[m
[32m+[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "Usuarios");[m
[32m+[m
[32m+[m[32m            migrationBuilder.DropTable([m
[32m+[m[32m                name: "Categorias");[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/Migrations/20260601223903_EcommerceDB.Designer.cs b/Migrations/20260601223903_EcommerceDB.Designer.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..fdb3210[m
[1m--- /dev/null[m
[1m+++ b/Migrations/20260601223903_EcommerceDB.Designer.cs[m
[36m@@ -0,0 +1,340 @@[m
[32m+[m[32m﻿// <auto-generated />[m
[32m+[m[32musing System;[m
[32m+[m[32musing EcommerceImportados.Data;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Infrastructure;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Metadata;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Migrations;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Storage.ValueConversion;[m
[32m+[m
[32m+[m[32m#nullable disable[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Migrations[m
[32m+[m[32m{[m
[32m+[m[32m    [DbContext(typeof(ApplicationDbContext))][m
[32m+[m[32m    [Migration("20260601223903_EcommerceDB")][m
[32m+[m[32m    partial class EcommerceDB[m
[32m+[m[32m    {[m
[32m+[m[32m        /// <inheritdoc />[m
[32m+[m[32m        protected override void BuildTargetModel(ModelBuilder modelBuilder)[m
[32m+[m[32m        {[m
[32m+[m[32m#pragma warning disable 612, 618[m
[32m+[m[32m            modelBuilder[m
[32m+[m[32m                .HasAnnotation("ProductVersion", "9.0.8")[m
[32m+[m[32m                .HasAnnotation("Relational:MaxIdentifierLength", 128);[m
[32m+[m
[32m+[m[32m            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("UsuarioId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("UsuarioId")[m
[32m+[m[32m                        .IsUnique();[m
[32m+[m
[32m+[m[32m                    b.ToTable("Carritos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Categoria", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(20)[m
[32m+[m[32m                        .HasColumnType("nvarchar(20)");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Categorias");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetalleCarrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Cantidad")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("CarritoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("PrecioUnitario")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("ProductoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("CarritoId");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("ProductoId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("DetallesCarrito");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetallePedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Cantidad")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("PedidoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("PrecioUnitario")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("ProductoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("PedidoId");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("ProductoId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("DetallesPedido");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<bool>("Activo")[m
[32m+[m[32m                        .HasColumnType("bit");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Estado")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<DateTime>("Fecha")[m
[32m+[m[32m                        .HasColumnType("datetime2");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("Total")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("UsuarioId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("UsuarioId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Pedidos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("CategoriaId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Descripcion")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(500)[m
[32m+[m[32m                        .HasColumnType("nvarchar(500)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("ImagenUrl")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(100)[m
[32m+[m[32m                        .HasColumnType("nvarchar(100)");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("Precio")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("SKU")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Stock")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("CategoriaId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Productos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Usuario", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Apellido")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(25)[m
[32m+[m[32m                        .HasColumnType("nvarchar(25)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("DNI")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Email")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(20)[m
[32m+[m[32m                        .HasColumnType("nvarchar(20)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Password")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Rol")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Usuarios");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Usuario", "Usuario")[m
[32m+[m[32m                        .WithOne("Carrito")[m
[32m+[m[32m                        .HasForeignKey("EcommerceImportados.Models.Carrito", "UsuarioId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Usuario");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetalleCarrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Carrito", "Carrito")[m
[32m+[m[32m                        .WithMany("Detalles")[m
[32m+[m[32m                        .HasForeignKey("CarritoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Producto", "Producto")[m
[32m+[m[32m                        .WithMany("DetallesCarrito")[m
[32m+[m[32m                        .HasForeignKey("ProductoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Carrito");[m
[32m+[m
[32m+[m[32m                    b.Navigation("Producto");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetallePedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Pedido", "Pedido")[m
[32m+[m[32m                        .WithMany("Detalles")[m
[32m+[m[32m                        .HasForeignKey("PedidoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Producto", "Producto")[m
[32m+[m[32m                        .WithMany("DetallesPedido")[m
[32m+[m[32m                        .HasForeignKey("ProductoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Pedido");[m
[32m+[m
[32m+[m[32m                    b.Navigation("Producto");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Usuario", "Usuario")[m
[32m+[m[32m                        .WithMany("Pedidos")[m
[32m+[m[32m                        .HasForeignKey("UsuarioId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Usuario");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Categoria", "Categoria")[m
[32m+[m[32m                        .WithMany("Productos")[m
[32m+[m[32m                        .HasForeignKey("CategoriaId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Categoria");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Detalles");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Categoria", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Productos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Detalles");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("DetallesCarrito");[m
[32m+[m
[32m+[m[32m                    b.Navigation("DetallesPedido");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Usuario", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Carrito")[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Pedidos");[m
[32m+[m[32m                });[m
[32m+[m[32m#pragma warning restore 612, 618[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/Migrations/20260601223903_EcommerceDB.cs b/Migrations/20260601223903_EcommerceDB.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..719ad67[m
[1m--- /dev/null[m
[1m+++ b/Migrations/20260601223903_EcommerceDB.cs[m
[36m@@ -0,0 +1,22 @@[m
[32m+[m[32m﻿using Microsoft.EntityFrameworkCore.Migrations;[m
[32m+[m
[32m+[m[32m#nullable disable[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Migrations[m
[32m+[m[32m{[m
[32m+[m[32m    /// <inheritdoc />[m
[32m+[m[32m    public partial class EcommerceDB : Migration[m
[32m+[m[32m    {[m
[32m+[m[32m        /// <inheritdoc />[m
[32m+[m[32m        protected override void Up(MigrationBuilder migrationBuilder)[m
[32m+[m[32m        {[m
[32m+[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        /// <inheritdoc />[m
[32m+[m[32m        protected override void Down(MigrationBuilder migrationBuilder)[m
[32m+[m[32m        {[m
[32m+[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/Migrations/ApplicationDbContextModelSnapshot.cs b/Migrations/ApplicationDbContextModelSnapshot.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..a1e6e9d[m
[1m--- /dev/null[m
[1m+++ b/Migrations/ApplicationDbContextModelSnapshot.cs[m
[36m@@ -0,0 +1,337 @@[m
[32m+[m[32m﻿// <auto-generated />[m
[32m+[m[32musing System;[m
[32m+[m[32musing EcommerceImportados.Data;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Infrastructure;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Metadata;[m
[32m+[m[32musing Microsoft.EntityFrameworkCore.Storage.ValueConversion;[m
[32m+[m
[32m+[m[32m#nullable disable[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.Migrations[m
[32m+[m[32m{[m
[32m+[m[32m    [DbContext(typeof(ApplicationDbContext))][m
[32m+[m[32m    partial class ApplicationDbContextModelSnapshot : ModelSnapshot[m
[32m+[m[32m    {[m
[32m+[m[32m        protected override void BuildModel(ModelBuilder modelBuilder)[m
[32m+[m[32m        {[m
[32m+[m[32m#pragma warning disable 612, 618[m
[32m+[m[32m            modelBuilder[m
[32m+[m[32m                .HasAnnotation("ProductVersion", "9.0.8")[m
[32m+[m[32m                .HasAnnotation("Relational:MaxIdentifierLength", 128);[m
[32m+[m
[32m+[m[32m            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("UsuarioId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("UsuarioId")[m
[32m+[m[32m                        .IsUnique();[m
[32m+[m
[32m+[m[32m                    b.ToTable("Carritos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Categoria", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(20)[m
[32m+[m[32m                        .HasColumnType("nvarchar(20)");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Categorias");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetalleCarrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Cantidad")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("CarritoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("PrecioUnitario")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("ProductoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("CarritoId");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("ProductoId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("DetallesCarrito");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetallePedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Cantidad")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("PedidoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("PrecioUnitario")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("ProductoId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("PedidoId");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("ProductoId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("DetallesPedido");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<bool>("Activo")[m
[32m+[m[32m                        .HasColumnType("bit");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Estado")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<DateTime>("Fecha")[m
[32m+[m[32m                        .HasColumnType("datetime2");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("Total")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("UsuarioId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("UsuarioId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Pedidos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<int>("CategoriaId")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Descripcion")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(500)[m
[32m+[m[32m                        .HasColumnType("nvarchar(500)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("ImagenUrl")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(100)[m
[32m+[m[32m                        .HasColumnType("nvarchar(100)");[m
[32m+[m
[32m+[m[32m                    b.Property<decimal>("Precio")[m
[32m+[m[32m                        .HasPrecision(18, 2)[m
[32m+[m[32m                        .HasColumnType("decimal(18,2)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("SKU")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Stock")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.HasIndex("CategoriaId");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Productos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Usuario", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Property<int>("Id")[m
[32m+[m[32m                        .ValueGeneratedOnAdd()[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("Id"));[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Apellido")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(25)[m
[32m+[m[32m                        .HasColumnType("nvarchar(25)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("DNI")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Email")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Nombre")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasMaxLength(20)[m
[32m+[m[32m                        .HasColumnType("nvarchar(20)");[m
[32m+[m
[32m+[m[32m                    b.Property<string>("Password")[m
[32m+[m[32m                        .IsRequired()[m
[32m+[m[32m                        .HasColumnType("nvarchar(max)");[m
[32m+[m
[32m+[m[32m                    b.Property<int>("Rol")[m
[32m+[m[32m                        .HasColumnType("int");[m
[32m+[m
[32m+[m[32m                    b.HasKey("Id");[m
[32m+[m
[32m+[m[32m                    b.ToTable("Usuarios");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Usuario", "Usuario")[m
[32m+[m[32m                        .WithOne("Carrito")[m
[32m+[m[32m                        .HasForeignKey("EcommerceImportados.Models.Carrito", "UsuarioId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Usuario");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetalleCarrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Carrito", "Carrito")[m
[32m+[m[32m                        .WithMany("Detalles")[m
[32m+[m[32m                        .HasForeignKey("CarritoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Producto", "Producto")[m
[32m+[m[32m                        .WithMany("DetallesCarrito")[m
[32m+[m[32m                        .HasForeignKey("ProductoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Carrito");[m
[32m+[m
[32m+[m[32m                    b.Navigation("Producto");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.DetallePedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Pedido", "Pedido")[m
[32m+[m[32m                        .WithMany("Detalles")[m
[32m+[m[32m                        .HasForeignKey("PedidoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Producto", "Producto")[m
[32m+[m[32m                        .WithMany("DetallesPedido")[m
[32m+[m[32m                        .HasForeignKey("ProductoId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Pedido");[m
[32m+[m
[32m+[m[32m                    b.Navigation("Producto");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Usuario", "Usuario")[m
[32m+[m[32m                        .WithMany("Pedidos")[m
[32m+[m[32m                        .HasForeignKey("UsuarioId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Usuario");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.HasOne("EcommerceImportados.Models.Categoria", "Categoria")[m
[32m+[m[32m                        .WithMany("Productos")[m
[32m+[m[32m                        .HasForeignKey("CategoriaId")[m
[32m+[m[32m                        .OnDelete(DeleteBehavior.Cascade)[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Categoria");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Carrito", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Detalles");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Categoria", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Productos");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Pedido", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Detalles");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Producto", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("DetallesCarrito");[m
[32m+[m
[32m+[m[32m                    b.Navigation("DetallesPedido");[m
[32m+[m[32m                });[m
[32m+[m
[32m+[m[32m            modelBuilder.Entity("EcommerceImportados.Models.Usuario", b =>[m
[32m+[m[32m                {[m
[32m+[m[32m                    b.Navigation("Carrito")[m
[32m+[m[32m                        .IsRequired();[m
[32m+[m
[32m+[m[32m                    b.Navigation("Pedidos");[m
[32m+[m[32m                });[m
[32m+[m[32m#pragma warning restore 612, 618[m
[32m+[m[32m        }[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/Models/Producto.cs b/Models/Producto.cs[m
[1mindex 73ecbec..e73e6d9 100644[m
[1m--- a/Models/Producto.cs[m
[1m+++ b/Models/Producto.cs[m
[36m@@ -26,12 +26,14 @@[m [mnamespace EcommerceImportados.Models[m
         [Range(0, int.MaxValue, ErrorMessage = "El stock no puede ser un número negativo.")][m
         public int Stock { get; set; }[m
 [m
[31m-        public string? ImagenUrl { get; set; }[m
[32m+[m[32m        [Required(ErrorMessage = "La URL de la imagen es obligatoria.")][m
[32m+[m[32m        [Url(ErrorMessage = "Debe ser una URL válida.")][m
[32m+[m[32m        public string ImagenUrl { get; set; } = string.Empty;[m
 [m
         [Required(ErrorMessage = "La categoría es obligatoria.")][m
         public int CategoriaId { get; set; }[m
 [m
[31m-        public Categoria? Categoria { get; set; }[m
[32m+[m[32m        public Categoria Categoria { get; set; } = null!;[m
 [m
         public ICollection<DetalleCarrito> DetallesCarrito { get; set; }[m
             = new List<DetalleCarrito>();[m
[1mdiff --git a/Program.cs b/Program.cs[m
[1mindex 1d3f335..582de39 100644[m
[1m--- a/Program.cs[m
[1m+++ b/Program.cs[m
[36m@@ -1,11 +1,20 @@[m
 using EcommerceImportados.Data;[m
 using Microsoft.EntityFrameworkCore;[m
[32m+[m[32musing Microsoft.AspNetCore.Authentication.Cookies;[m
 [m
 var builder = WebApplication.CreateBuilder(args);[m
 [m
 // Add services to the container.[m
 builder.Services.AddControllersWithViews();[m
 [m
[32m+[m[32mbuilder.Services.AddAuthentication([m
[32m+[m[32m    CookieAuthenticationDefaults.AuthenticationScheme)[m
[32m+[m[32m    .AddCookie(options =>[m
[32m+[m[32m    {[m
[32m+[m[32m        options.LoginPath = "/Account/Login";[m
[32m+[m[32m        options.AccessDeniedPath = "/Account/Login";[m
[32m+[m[32m    });[m
[32m+[m
 builder.Services.AddDbContext<ApplicationDbContext>(options =>[m
     options.UseSqlServer([m
         builder.Configuration.GetConnectionString("DefaultConnection")));[m
[36m@@ -25,6 +34,7 @@[m [mapp.UseRouting();[m
 [m
 app.UseStaticFiles();[m
 [m
[32m+[m[32mapp.UseAuthentication();[m
 app.UseAuthorization();[m
 [m
 app.MapStaticAssets();[m
[1mdiff --git a/Services/CarritoService.cs b/Services/CarritoService.cs[m
[1mdeleted file mode 100644[m
[1mindex dd6523a..0000000[m
[1m--- a/Services/CarritoService.cs[m
[1m+++ /dev/null[m
[36m@@ -1,24 +0,0 @@[m
[31m-﻿using EcommerceImportados.Data;[m
[31m-[m
[31m-namespace EcommerceImportados.Services[m
[31m-{[m
[31m-    public class CarritoService[m
[31m-    {[m
[31m-        private readonly ApplicationDbContext _context;[m
[31m-[m
[31m-        public CarritoService(ApplicationDbContext context)[m
[31m-        {[m
[31m-            _context = context;[m
[31m-        }[m
[31m-[m
[31m-        public void AgregarProducto(int productoId)[m
[31m-        {[m
[31m-[m
[31m-        }[m
[31m-[m
[31m-        public decimal ObtenerTotal()[m
[31m-        {[m
[31m-            return 0m;[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[1mdiff --git a/ViewModels/LoginViewModel.cs b/ViewModels/LoginViewModel.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..777af1e[m
[1m--- /dev/null[m
[1m+++ b/ViewModels/LoginViewModel.cs[m
[36m@@ -0,0 +1,14 @@[m
[32m+[m[32m﻿using System.ComponentModel.DataAnnotations;[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.ViewModels[m
[32m+[m[32m{[m
[32m+[m[32m    public class LoginViewModel[m
[32m+[m[32m    {[m
[32m+[m[32m        [Required][m
[32m+[m[32m        [EmailAddress][m
[32m+[m[32m        public string Email { get; set; } = "";[m
[32m+[m
[32m+[m[32m        [Required][m
[32m+[m[32m        public string Password { get; set; } = "";[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
\ No newline at end of file[m
[1mdiff --git a/ViewModels/RegisterViewModel.cs b/ViewModels/RegisterViewModel.cs[m
[1mnew file mode 100644[m
[1mindex 0000000..763a452[m
[1m--- /dev/null[m
[1m+++ b/ViewModels/RegisterViewModel.cs[m
[36m@@ -0,0 +1,25 @@[m
[32m+[m[32m﻿using System.ComponentModel.DataAnnotations;[m
[32m+[m
[32m+[m[32mnamespace EcommerceImportados.ViewModels[m
[32m+[m[32m{[m
[32m+[m[32m    public class RegisterViewModel[m
[32m+[m[32m    {[m
[32m+[m[32m        [Required][m
[32m+[m[32m        public string Nombre { get; set; } = "";[m
[32m+[m
[32m+[m[32m        [Required][m
[32m+[m[32m        public string Apellido { get; set; } = "";[m
[32m+[m
[32m+[m[32m        [Required][m
[32m+[m[32m        [EmailAddress][m
[32m+[m[32m        public string Email { get; set; } = "";[m
[32m+[m
[32m+[m[32m        [Required][m
[32m+[m[32m        [RegularExpression(@"^\d{7,8}$")][m
[32m+[m[32m        public string DNI { get; set; } = "";[m
[32m+[m
[32m+[m[32m        [Required][m
[32m+[m[32m        [MinLength(8)][m
[32m+[m[32m        public string Password { get; set; } = "";[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
\ No newline at end of file[m
[1mdiff --git a/Views/Account/HistorialCompras.cshtml b/Views/Account/HistorialCompras.cshtml[m
[1mnew file mode 100644[m
[1mindex 0000000..80f3201[m
[1m--- /dev/null[m
[1m+++ b/Views/Account/HistorialCompras.cshtml[m
[36m@@ -0,0 +1,26 @@[m
[32m+[m[32m﻿@model IEnumerable<EcommerceImportados.Models.Pedido>[m
[32m+[m
[32m+[m[32m<h2>Mis Compras</h2>[m
[32m+[m
[32m+[m[32m<table class="table">[m
[32m+[m[32m    <thead>[m
[32m+[m[32m        <tr>[m
[32m+[m[32m            <th>Pedido</th>[m
[32m+[m[32m            <th>Fecha</th>[m
[32m+[m[32m            <th>Total</th>[m
[32m+[m[32m            <th>Estado</th>[m
[32m+[m[32m        </tr>[m
[32m+[m[32m    </thead>[m
[32m+[m
[32m+[m[32m    <tbody>[m
[32m+[m[32m        @foreach (var pedido in Model)[m
[32m+[m[32m        {[m
[32m+[m[32m            <tr>[m
[32m+[m[32m                <td>@pedido.Id</td>[m
[32m+[m[32m                <td>@pedido.Fecha</td>[m
[32m+[m[32m                <td>$@pedido.Total</td>[m
[32m+[m[32m                <td>@pedido.Estado</td>[m
[32m+[m[32m            </tr>[m
[32m+[m[32m        }[m
[32m+[m[32m    </tbody>[m
[32m+[m[32m</table>[m
[1mdiff --git a/Views/Account/Login.cshtml b/Views/Account/Login.cshtml[m
[1mnew file mode 100644[m
[1mindex 0000000..dd7dab3[m
[1m--- /dev/null[m
[1m+++ b/Views/Account/Login.cshtml[m
[36m@@ -0,0 +1,19 @@[m
[32m+[m[32m﻿@model EcommerceImportados.ViewModels.LoginViewModel[m
[32m+[m
[32m+[m[32m<h2>Login</h2>[m
[32m+[m
[32m+[m[32m<form asp-action="Login" method="post">[m
[32m+[m
[32m+[m[32m    <input asp-for="Email" placeholder="Email" />[m
[32m+[m[32m    <span asp-validation-for="Email"></span>[m
[32m+[m
[32m+[m[32m    <input asp-for="Password"[m
[32m+[m[32m           type="password"[m
[32m+[m[32m           placeholder="Contraseña" />[m
[32m+[m[32m    <span asp-validation-for="Password"></span>[m
[32m+[m
[32m+[m[32m    <button type="submit">[m
[32m+[m[32m        Ingresar[m
[32m+[m[32m    </button>[m
[32m+[m
[32m+[m[32m</form>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Account/Register.cshtml b/Views/Account/Register.cshtml[m
[1mnew file mode 100644[m
[1mindex 0000000..b39c773[m
[1m--- /dev/null[m
[1m+++ b/Views/Account/Register.cshtml[m
[36m@@ -0,0 +1,24 @@[m
[32m+[m[32m﻿@model EcommerceImportados.ViewModels.RegisterViewModel[m
[32m+[m
[32m+[m[32m<h2>Registro</h2>[m
[32m+[m
[32m+[m[32m<form asp-action="Register" method="post">[m
[32m+[m
[32m+[m[32m    <input asp-for="Nombre" placeholder="Nombre" />[m
[32m+[m[32m    <span asp-validation-for="Nombre"></span>[m
[32m+[m
[32m+[m[32m    <input asp-for="Apellido" placeholder="Apellido" />[m
[32m+[m[32m    <span asp-validation-for="Apellido"></span>[m
[32m+[m
[32m+[m[32m    <input asp-for="Email" placeholder="Email" />[m
[32m+[m[32m    <span asp-validation-for="Email"></span>[m
[32m+[m
[32m+[m[32m    <input asp-for="DNI" placeholder="DNI" />[m
[32m+[m[32m    <span asp-validation-for="DNI"></span>[m
[32m+[m
[32m+[m[32m    <input asp-for="Password" type="password" placeholder="Contraseña" />[m
[32m+[m[32m    <span asp-validation-for="Password"></span>[m
[32m+[m
[32m+[m[32m    <button type="submit">Registrarse</button>[m
[32m+[m
[32m+[m[32m</form>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Carrito/Index.cshtml b/Views/Carrito/Index.cshtml[m
[1mdeleted file mode 100644[m
[1mindex d61d53e..0000000[m
[1m--- a/Views/Carrito/Index.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,51 +0,0 @@[m
[31m-﻿@model IEnumerable<EcommerceImportados.Models.DetalleCarrito>[m
[31m-[m
[31m-<!DOCTYPE html>[m
[31m-<html lang="es">[m
[31m-<head>[m
[31m-    <meta charset="UTF-8">[m
[31m-    <title>Ecommerce Importados</title>[m
[31m-    <link rel="stylesheet"[m
[31m-          href="~/css/style.css">[m
[31m-</head>[m
[31m-<body>[m
[31m-[m
[31m-    <header>[m
[31m-[m
[31m-    </header>[m
[31m-[m
[31m-    <section class="Carrito">[m
[31m-[m
[31m-        <h2>Mi Carrito</h2>[m
[31m-[m
[31m-    </section>[m
[31m-[m
[31m-    <h1>Mi Carrito</h1>[m
[31m-[m
[31m-    <table>[m
[31m-        <thead>[m
[31m-            <tr>[m
[31m-                <th>Producto</th>[m
[31m-                <th>Precio</th>[m
[31m-                <th>Cantidad</th>[m
[31m-            </tr>[m
[31m-        </thead>[m
[31m-[m
[31m-        <tbody>[m
[31m-            @foreach (var item in Model)[m
[31m-            {[m
[31m-                <tr>[m
[31m-                    <td>@item.Producto.Nombre</td>[m
[31m-                    <td>$@item.PrecioUnitario</td>[m
[31m-                    <td>@item.Cantidad</td>[m
[31m-                </tr>[m
[31m-            }[m
[31m-        </tbody>[m
[31m-    </table>[m
[31m-[m
[31m-    <footer>[m
[31m-        <p>© 2026 Ecommerce Importados</p>[m
[31m-    </footer>[m
[31m-[m
[31m-</body>[m
[31m-</html>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Carrito/Index.cshtml.cs b/Views/Carrito/Index.cshtml.cs[m
[1mdeleted file mode 100644[m
[1mindex 9c11be3..0000000[m
[1m--- a/Views/Carrito/Index.cshtml.cs[m
[1m+++ /dev/null[m
[36m@@ -1,12 +0,0 @@[m
[31m-using Microsoft.AspNetCore.Mvc;[m
[31m-using Microsoft.AspNetCore.Mvc.RazorPages;[m
[31m-[m
[31m-namespace EcommerceImportados.Views.Carrito[m
[31m-{[m
[31m-    public class IndexModel : PageModel[m
[31m-    {[m
[31m-        public void OnGet()[m
[31m-        {[m
[31m-        }[m
[31m-    }[m
[31m-}[m
[1mdiff --git a/Views/Categorias/Index.cshtml b/Views/Categorias/Index.cshtml[m
[1mdeleted file mode 100644[m
[1mindex 6eb516c..0000000[m
[1m--- a/Views/Categorias/Index.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,123 +0,0 @@[m
[31m-﻿@model IEnumerable<EcommerceImportados.Models.Categoria>[m
[31m-[m
[31m-@{[m
[31m-    ViewData["Title"] = "Panel de Categorías";[m
[31m-}[m
[31m-[m
[31m-<div class="container my-5">[m
[31m-    <div class="d-flex justify-content-between align-items-center mb-4">[m
[31m-        <div>[m
[31m-            <h1 class="fw-bold h3 text-dark">Administración de Categorías</h1>[m
[31m-            <p class="text-muted small">Creá, editá o eliminá las categorías visibles en el catálogo.</p>[m
[31m-        </div>[m
[31m-        <button type="button" class="btn btn-dark rounded-0 text-uppercase fw-bold px-4 btn-sm" data-bs-toggle="modal" data-bs-target="#createModal">[m
[31m-            Nueva Categoría[m
[31m-        </button>[m
[31m-    </div>[m
[31m-[m
[31m-    <div class="card border-0 shadow-sm rounded-0">[m
[31m-        <div class="table-responsive">[m
[31m-            <table class="table table-hover align-middle mb-0">[m
[31m-                <thead class="table-light">[m
[31m-                    <tr class="text-uppercase text-muted small" style="font-size: 0.75rem; letter-spacing: 0.05em;">[m
[31m-                        <th class="ps-4">ID</th>[m
[31m-                        <th>Nombre de la Categoría</th>[m
[31m-                        <th class="text-end pe-4">Acciones</th>[m
[31m-                    </tr>[m
[31m-                </thead>[m
[31m-                <tbody>[m
[31m-                    @if (Model != null && Model.Any())[m
[31m-                    {[m
[31m-                        foreach (var item in Model)[m
[31m-                        {[m
[31m-                            <tr>[m
[31m-                                <td class="ps-4 fw-bold text-muted">#@item.Id</td>[m
[31m-                                <td class="fw-semibold text-dark">@item.Nombre</td>[m
[31m-                                <td class="text-end pe-4">[m
[31m-                                    <button class="btn btn-sm btn-outline-secondary rounded-0 me-2" data-bs-toggle="modal" data-bs-target="#editModal-@item.Id">[m
[31m-                                        Editar[m
[31m-                                    </button>[m
[31m-                                    <button class="btn btn-sm btn-outline-danger rounded-0" data-bs-toggle="modal" data-bs-target="#deleteModal-@item.Id">[m
[31m-                                        Eliminar[m
[31m-                                    </button>[m
[31m-                                </td>[m
[31m-                            </tr>[m
[31m-[m
[31m-                            <div class="modal fade" id="editModal-@item.Id" database-bs-backdrop="static" tabindex="-1">[m
[31m-                                <div class="modal-dialog modal-dialog-centered">[m
[31m-                                    <div class="modal-content rounded-0 border-0 shadow">[m
[31m-                                        <form asp-action="Edit" asp-route-id="@item.Id" method="post">[m
[31m-                                            @Html.AntiForgeryToken()[m
[31m-                                            <input type="hidden" name="Id" value="@item.Id" />[m
[31m-                                            <div class="modal-header border-0 pb-0">[m
[31m-                                                <h5 class="modal-title fw-bold">Editar Categoría</h5>[m
[31m-                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>[m
[31m-                                            </div>[m
[31m-                                            <div class="modal-body py-3">[m
[31m-                                                <label class="form-label small fw-semibold text-muted text-uppercase">Nombre</label>[m
[31m-                                                <input type="text" name="Nombre" class="form-control rounded-0" value="@item.Nombre" required />[m
[31m-                                            </div>[m
[31m-                                            <div class="modal-footer border-0 pt-0">[m
[31m-                                                <button type="button" class="btn btn-sm btn-light rounded-0" data-bs-dismiss="modal">Cancelar</button>[m
[31m-                                                <button type="submit" class="btn btn-sm btn-dark rounded-0 px-3">Guardar Cambios</button>[m
[31m-                                            </div>[m
[31m-                                        </form>[m
[31m-                                    </div>[m
[31m-                                </div>[m
[31m-                            </div>[m
[31m-[m
[31m-                            <div class="modal fade" id="deleteModal-@item.Id" tabindex="-1">[m
[31m-                                <div class="modal-dialog modal-dialog-centered">[m
[31m-                                    <div class="modal-content rounded-0 border-0 shadow">[m
[31m-                                        <form asp-action="Delete" asp-route-id="@item.Id" method="post">[m
[31m-                                            @Html.AntiForgeryToken()[m
[31m-                                            <div class="modal-header border-0 pb-0">[m
[31m-                                                <h5 class="modal-title fw-bold text-danger">¿Eliminar Categoría?</h5>[m
[31m-                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>[m
[31m-                                            </div>[m
[31m-                                            <div class="modal-body py-3">[m
[31m-                                                <p class="mb-0">¿Estás seguro de que querés borrar <strong>@item.Nombre</strong>? Esta acción no se puede deshacer.</p>[m
[31m-                                            </div>[m
[31m-                                            <div class="modal-footer border-0 pt-0">[m
[31m-                                                <button type="button" class="btn btn-sm btn-light rounded-0" data-bs-dismiss="modal">Cancelar</button>[m
[31m-                                                <button type="submit" class="btn btn-sm btn-danger rounded-0 px-3">Eliminar</button>[m
[31m-                                            </div>[m
[31m-                                        </form>[m
[31m-                                    </div>[m
[31m-                                </div>[m
[31m-                            </div>[m
[31m-                        }[m
[31m-                    }[m
[31m-                    else[m
[31m-                    {[m
[31m-                        <tr>[m
[31m-                            <td colspan="3" class="text-center py-4 text-muted small">No hay categorías creadas todavía.</td>[m
[31m-                        </tr>[m
[31m-                    }[m
[31m-                </tbody>[m
[31m-            </table>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-</div>[m
[31m-[m
[31m-<div class="modal fade" id="createModal" database-bs-backdrop="static" tabindex="-1">[m
[31m-    <div class="modal-dialog modal-dialog-centered">[m
[31m-        <div class="modal-content rounded-0 border-0 shadow">[m
[31m-            <form asp-action="Create" method="post">[m
[31m-                @Html.AntiForgeryToken()[m
[31m-                <div class="modal-header border-0 pb-0">[m
[31m-                    <h5 class="modal-title fw-bold">Nueva Categoría</h5>[m
[31m-                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>[m
[31m-                </div>[m
[31m-                <div class="modal-body py-3">[m
[31m-                    <label class="form-label small fw-semibold text-muted text-uppercase">Nombre de la Categoría</label>[m
[31m-                    <input type="text" name="Nombre" class="form-control rounded-0" placeholder="Categoria" required />[m
[31m-                </div>[m
[31m-                <div class="modal-footer border-0 pt-0">[m
[31m-                    <button type="button" class="btn btn-sm btn-light rounded-0" data-bs-dismiss="modal">Cancelar</button>[m
[31m-                    <button type="submit" class="btn btn-sm btn-dark rounded-0 px-3">Crear</button>[m
[31m-                </div>[m
[31m-            </form>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-</div>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Home/Home.html b/Views/Home/Home.html[m
[1mnew file mode 100644[m
[1mindex 0000000..a8e2e21[m
[1m--- /dev/null[m
[1m+++ b/Views/Home/Home.html[m
[36m@@ -0,0 +1,67 @@[m
[32m+[m[32m@{[m
[32m+[m[32m    ViewData["Title"] = "Home Page";[m
[32m+[m[32m}[m
[32m+[m
[32m+[m[32m<!DOCTYPE html>[m
[32m+[m[32m<html lang="es">[m
[32m+[m[32m<head>[m
[32m+[m[32m    <meta charset="UTF-8">[m
[32m+[m[32m    <title>Ecommerce Importados</title>[m
[32m+[m[32m    <link rel="stylesheet" href="C:\Users\ferru\source\repos\EcommerceImportados\wwwroot\css\style.css">[m
[32m+[m[32m</head>[m
[32m+[m[32m<body>[m
[32m+[m
[32m+[m[32m    <header>[m
[32m+[m[32m        <nav class="navbar">[m
[32m+[m[32m            <h1>Ecommerce Importados</h1>[m
[32m+[m
[32m+[m[32m            <ul>[m
[32m+[m[32m                <li><a href="#">Inicio</a></li>[m
[32m+[m[32m                <li><a href="#">Productos</a></li>[m
[32m+[m[32m                <li><a href="#">Carrito 🛒</a></li>[m
[32m+[m[32m                <li><a href="#">Login</a></li>[m
[32m+[m[32m            </ul>[m
[32m+[m[32m        </nav>[m
[32m+[m[32m    </header>[m
[32m+[m
[32m+[m[32m    <section class="hero">[m
[32m+[m[32m        <h2>Bienvenido a nuestra tienda</h2>[m
[32m+[m[32m        <p>Los mejores productos importados al mejor precio.</p>[m
[32m+[m[32m        <a href="#" class="btn">Ver Productos</a>[m
[32m+[m[32m    </section>[m
[32m+[m
[32m+[m[32m    <section class="productos">[m
[32m+[m[32m        <h2>Productos Destacados</h2>[m
[32m+[m
[32m+[m[32m        <div class="contenedor-productos">[m
[32m+[m
[32m+[m[32m            <div class="card">[m
[32m+[m[32m                <img src="https://via.placeholder.com/250" alt="Producto">[m
[32m+[m[32m                <h3>Mouse Gamer</h3>[m
[32m+[m[32m                <p>$25.000</p>[m
[32m+[m[32m                <button>Agregar al carrito</button>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <div class="card">[m
[32m+[m[32m                <img src="https://via.placeholder.com/250" alt="Producto">[m
[32m+[m[32m                <h3>Teclado Mecánico</h3>[m
[32m+[m[32m                <p>$65.000</p>[m
[32m+[m[32m                <button>Agregar al carrito</button>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <div class="card">[m
[32m+[m[32m                <img src="https://via.placeholder.com/250" alt="Producto">[m
[32m+[m[32m                <h3>Auriculares</h3>[m
[32m+[m[32m                <p>$48.000</p>[m
[32m+[m[32m                <button>Agregar al carrito</button>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m        </div>[m
[32m+[m[32m    </section>[m
[32m+[m
[32m+[m[32m    <footer>[m
[32m+[m[32m        <p>© 2026 Ecommerce Importados</p>[m
[32m+[m[32m    </footer>[m
[32m+[m
[32m+[m[32m</body>[m
[32m+[m[32m</html>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Home/Index.cshtml b/Views/Home/Index.cshtml[m
[1mindex 1bd652f..e836398 100644[m
[1m--- a/Views/Home/Index.cshtml[m
[1m+++ b/Views/Home/Index.cshtml[m
[36m@@ -1,22 +1,68 @@[m
[31m-﻿@model IEnumerable<EcommerceImportados.Models.Producto>[m
[31m-[m
[31m-@{[m
[31m-    ViewData["Title"] = "Welcome";[m
[32m+[m[32m﻿@{[m
[32m+[m[32m    ViewData["Title"] = "Home Page";[m
 }[m
 [m
[31m-<section class="bg-light text-dark py-5 border-bottom">[m
[31m-    <div class="container my-5 py-4 text-center">[m
[31m-        <p class="text-uppercase text-muted fw-bold small mb-2" style="letter-spacing: 0.2em;">Del mundo a tu puerta</p>[m
[31m-        <h1 class="display-4 fw-bold text-uppercase tracking-tight mb-3" style="letter-spacing: -0.02em;">[m
[31m-            Global Imports[m
[31m-        </h1>[m
[31m-        <p class="lead text-muted mx-auto mb-4" style="max-width: 600px; font-size: 1.1rem;">[m
[31m-            Comprá productos internacionales de cualquier parte del mundo.[m
[31m-        </p>[m
[31m-        <div class="d-flex justify-content-center gap-3">[m
[31m-            <a href="/productos" class="btn btn-dark rounded-0 text-uppercase fw-bold px-4 py-2 small" style="letter-spacing: 0.05em;">[m
[31m-                Explorar Catálogo[m
[31m-            </a>[m
[32m+[m[32m<!DOCTYPE html>[m
[32m+[m[32m<html lang="es">[m
[32m+[m[32m<head>[m
[32m+[m[32m    <meta charset="UTF-8">[m
[32m+[m[32m    <title>Ecommerce Importados</title>[m
[32m+[m[32m    <link rel="stylesheet"[m
[32m+[m[32m          href="~/css/style.css">[m
[32m+[m[32m</head>[m
[32m+[m[32m<body>[m
[32m+[m
[32m+[m[32m    <header>[m
[32m+[m[32m        <nav class="navbar">[m
[32m+[m[32m            <h1>Ecommerce Importados</h1>[m
[32m+[m
[32m+[m[32m            <ul>[m
[32m+[m[32m                <li><a href="#">Inicio</a></li>[m
[32m+[m[32m                <li><a href="#">Productos</a></li>[m
[32m+[m[32m                <li><a href="#">Carrito 🛒</a></li>[m
[32m+[m[32m                <li><a href="#">Login</a></li>[m
[32m+[m[32m            </ul>[m
[32m+[m[32m        </nav>[m
[32m+[m[32m    </header>[m
[32m+[m
[32m+[m[32m    <section class="hero">[m
[32m+[m[32m        <h2>Bienvenido a nuestra tienda</h2>[m
[32m+[m[32m        <p>Los mejores productos importados al mejor precio.</p>[m
[32m+[m[32m        <a href="#" class="btn">Ver Productos</a>[m
[32m+[m[32m    </section>[m
[32m+[m
[32m+[m[32m    <section class="productos">[m
[32m+[m[32m        <h2>Productos Destacados</h2>[m
[32m+[m
[32m+[m[32m        <div class="contenedor-productos">[m
[32m+[m
[32m+[m[32m            <div class="card">[m
[32m+[m[32m                <img src="https://via.placeholder.com/250" alt="Producto">[m
[32m+[m[32m                <h3>Mouse Gamer</h3>[m
[32m+[m[32m                <p>$25.000</p>[m
[32m+[m[32m                <button>Agregar al carrito</button>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <div class="card">[m
[32m+[m[32m                <img src="https://via.placeholder.com/250" alt="Producto">[m
[32m+[m[32m                <h3>Teclado Mecánico</h3>[m
[32m+[m[32m                <p>$65.000</p>[m
[32m+[m[32m                <button>Agregar al carrito</button>[m
[32m+[m[32m            </div>[m
[32m+[m
[32m+[m[32m            <div class="card">[m
[32m+[m[32m                <img src="https://via.placeholder.com/250" alt="Producto">[m
[32m+[m[32m                <h3>Auriculares</h3>[m
[32m+[m[32m                <p>$48.000</p>[m
[32m+[m[32m                <button>Agregar al carrito</button>[m
[32m+[m[32m            </div>[m
[32m+[m
         </div>[m
[31m-    </div>[m
[31m-</section>[m
[32m+[m[32m    </section>[m
[32m+[m
[32m+[m[32m    <footer>[m
[32m+[m[32m        <p>© 2026 Ecommerce Importados</p>[m
[32m+[m[32m    </footer>[m
[32m+[m
[32m+[m[32m</body>[m
[32m+[m[32m</html>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Producto/Admin.cshtml b/Views/Producto/Admin.cshtml[m
[1mdeleted file mode 100644[m
[1mindex d6900a3..0000000[m
[1m--- a/Views/Producto/Admin.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,86 +0,0 @@[m
[31m-﻿@model IEnumerable<EcommerceImportados.Models.Producto>[m
[31m-[m
[31m-@{[m
[31m-    ViewData["Title"] = "Admin Productos";[m
[31m-}[m
[31m-[m
[31m-<div class="container my-5">[m
[31m-    <div class="d-flex justify-content-between align-items-center mb-4">[m
[31m-        <div>[m
[31m-            <h1 class="fw-bold h3 text-dark">Panel de Productos</h1>[m
[31m-            <p class="text-muted small">Administración de stock, precios y catálogos.</p>[m
[31m-        </div>[m
[31m-        <a asp-action="Create" class="btn btn-dark rounded-0 text-uppercase fw-bold px-4 btn-sm">Nuevo Producto</a>[m
[31m-    </div>[m
[31m-[m
[31m-    <div class="card border-0 shadow-sm rounded-0">[m
[31m-        <div class="table-responsive">[m
[31m-            <table class="table table-hover align-middle mb-0">[m
[31m-                <thead class="table-light">[m
[31m-                    <tr class="text-uppercase text-muted small" style="font-size: 0.75rem; letter-spacing: 0.05em;">[m
[31m-                        <th class="ps-4">Imagen</th>[m
[31m-                        <th>Producto</th>[m
[31m-                        <th>SKU</th>[m
[31m-                        <th>Categoría</th>[m
[31m-                        <th>Precio</th>[m
[31m-                        <th>Stock</th>[m
[31m-                        <th class="text-end pe-4">Acciones</th>[m
[31m-                    </tr>[m
[31m-                </thead>[m
[31m-                <tbody>[m
[31m-                    @if (Model != null && Model.Any())[m
[31m-                    {[m
[31m-                        foreach (var item in Model)[m
[31m-                        {[m
[31m-                            <tr>[m
[31m-                                <td class="ps-4">[m
[31m-                                    <img src="@item.ImagenUrl" alt="Thumb" class="object-fit-cover border" style="width: 50px; height: 50px;">[m
[31m-                                </td>[m
[31m-                                <td>[m
[31m-                                    <div class="fw-bold text-dark">@item.Nombre</div>[m
[31m-                                </td>[m
[31m-                                <td class="text-muted">@item.SKU</td>[m
[31m-                                <td><span class="badge bg-light text-dark border">@item.Categoria?.Nombre</span></td>[m
[31m-                                <td class="fw-bold text-dark">$@item.Precio.ToString("N2")</td>[m
[31m-                                <td>[m
[31m-                                    <span class="fw-semibold @(item.Stock == 0 ? "text-danger" : "text-muted")">@item.Stock un.</span>[m
[31m-                                </td>[m
[31m-                                <td class="text-end pe-4">[m
[31m-                                    <a asp-action="Edit" asp-route-id="@item.Id" class="btn btn-sm btn-outline-secondary rounded-0 me-1">Editar</a>[m
[31m-                                    <button class="btn btn-sm btn-outline-danger rounded-0" data-bs-toggle="modal" data-bs-target="#deleteModal-@item.Id">Eliminar</button>[m
[31m-                                </td>[m
[31m-                            </tr>[m
[31m-[m
[31m-                            <div class="modal fade" id="deleteModal-@item.Id" tabindex="-1">[m
[31m-                                <div class="modal-dialog modal-dialog-centered">[m
[31m-                                    <div class="modal-content rounded-0 border-0 shadow">[m
[31m-                                        <form asp-action="Delete" asp-route-id="@item.Id" method="post">[m
[31m-                                            @Html.AntiForgeryToken()[m
[31m-                                            <div class="modal-header border-0 pb-0">[m
[31m-                                                <h5 class="modal-title fw-bold text-danger">¿Eliminar Producto?</h5>[m
[31m-                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>[m
[31m-                                            </div>[m
[31m-                                            <div class="modal-body py-3">[m
[31m-                                                <p class="mb-0">¿Estás seguro de eliminar <strong>@item.Nombre</strong>?</p>[m
[31m-                                            </div>[m
[31m-                                            <div class="modal-footer border-0 pt-0">[m
[31m-                                                <button type="button" class="btn btn-sm btn-light rounded-0" data-bs-dismiss="modal">Cancelar</button>[m
[31m-                                                <button type="submit" class="btn btn-sm btn-danger rounded-0 px-3">Confirmar</button>[m
[31m-                                            </div>[m
[31m-                                        </form>[m
[31m-                                    </div>[m
[31m-                                </div>[m
[31m-                            </div>[m
[31m-                        }[m
[31m-                    }[m
[31m-                    else[m
[31m-                    {[m
[31m-                        <tr>[m
[31m-                            <td colspan="7" class="text-center py-4 text-muted small">No hay productos creados todavía.</td>[m
[31m-                        </tr>[m
[31m-                    }[m
[31m-                </tbody>[m
[31m-            </table>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-</div>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Producto/Create.cshtml b/Views/Producto/Create.cshtml[m
[1mdeleted file mode 100644[m
[1mindex c06b47c..0000000[m
[1m--- a/Views/Producto/Create.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,66 +0,0 @@[m
[31m-﻿@model EcommerceImportados.Models.Producto[m
[31m-[m
[31m-@{[m
[31m-    ViewData["Title"] = "Nuevo Producto";[m
[31m-}[m
[31m-[m
[31m-<div class="container my-5" style="max-width: 600px;">[m
[31m-    <div class="mb-4">[m
[31m-        <h1 class="fw-bold h3 text-dark">Crear Producto</h1>[m
[31m-        <p class="text-muted small">Cargá un producto al catálogo.</p>[m
[31m-    </div>[m
[31m-[m
[31m-    <div class="card border-0 shadow-sm rounded-0 p-4">[m
[31m-        <div asp-validation-summary="All" class="text-danger fw-bold small mb-3"></div>[m
[31m-        <form asp-action="Create" method="post">[m
[31m-            @Html.AntiForgeryToken()[m
[31m-[m
[31m-            <div class="mb-3">[m
[31m-                <label asp-for="Nombre" class="form-label small fw-bold text-uppercase text-muted">Nombre</label>[m
[31m-                <input asp-for="Nombre" class="form-control rounded-0" required />[m
[31m-                <span asp-validation-for="Nombre" class="text-danger small"></span>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="mb-3">[m
[31m-                <label asp-for="Descripcion" class="form-label small fw-bold text-uppercase text-muted">Descripción</label>[m
[31m-                <textarea asp-for="Descripcion" class="form-control rounded-0" rows="3"></textarea>[m
[31m-                <span asp-validation-for="Descripcion" class="text-danger small"></span>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="row">[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="CategoriaId" class="form-label small fw-bold text-uppercase text-muted">Categoría</label>[m
[31m-                    <select asp-for="CategoriaId" class="form-select rounded-0" asp-items="ViewBag.CategoriaId" required></select>[m
[31m-                </div>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="row">[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="Precio" class="form-label small fw-bold text-uppercase text-muted">Precio ($)</label>[m
[31m-                    <input asp-for="Precio" type="number" step="0.01" class="form-control rounded-0" required />[m
[31m-                    <span asp-validation-for="Precio" class="text-danger small"></span>[m
[31m-                </div>[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="Stock" class="form-label small fw-bold text-uppercase text-muted">Stock Disponible</label>[m
[31m-                    <input asp-for="Stock" type="number" class="form-control rounded-0" required />[m
[31m-                    <span asp-validation-for="Stock" class="text-danger small"></span>[m
[31m-                </div>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="mb-4">[m
[31m-                <label asp-for="ImagenUrl" class="form-label small fw-bold text-uppercase text-muted">URL de la Imagen</label>[m
[31m-                <input asp-for="ImagenUrl" type="text" class="form-control rounded-0" placeholder="https://ejemplo.com/imagen.jpg" />[m
[31m-                <span asp-validation-for="ImagenUrl" class="text-danger small"></span>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="d-flex justify-content-end gap-2">[m
[31m-                <a asp-action="Admin" class="btn btn-light rounded-0 btn-sm px-3">Volver</a>[m
[31m-                <button type="submit" class="btn btn-dark rounded-0 btn-sm px-4 fw-bold">Guardar Producto</button>[m
[31m-            </div>[m
[31m-        </form>[m
[31m-    </div>[m
[31m-</div>[m
[31m-[m
[31m-@section Scripts {[m
[31m-    <partial name="_ValidationScriptsPartial" />[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/Views/Producto/Edit.cshtml b/Views/Producto/Edit.cshtml[m
[1mdeleted file mode 100644[m
[1mindex 5df5b40..0000000[m
[1m--- a/Views/Producto/Edit.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,71 +0,0 @@[m
[31m-﻿@model EcommerceImportados.Models.Producto[m
[31m-[m
[31m-@{[m
[31m-    ViewData["Title"] = "Editar Producto";[m
[31m-}[m
[31m-[m
[31m-<div class="container my-5" style="max-width: 600px;">[m
[31m-    <div class="mb-4">[m
[31m-        <h1 class="fw-bold h3 text-dark">Editar Producto</h1>[m
[31m-        <p class="text-muted small">Modificá los detalles comerciales del artículo seleccionado.</p>[m
[31m-    </div>[m
[31m-[m
[31m-    <div class="card border-0 shadow-sm rounded-0 p-4">[m
[31m-        <form asp-action="Edit" method="post">[m
[31m-            @Html.AntiForgeryToken()[m
[31m-            <input type="hidden" asp-for="Id" />[m
[31m-[m
[31m-            <div class="mb-3">[m
[31m-                <label asp-for="Nombre" class="form-label small fw-bold text-uppercase text-muted">Nombre</label>[m
[31m-                <input asp-for="Nombre" class="form-control rounded-0" required />[m
[31m-                <span asp-validation-for="Nombre" class="text-danger small"></span>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="mb-3">[m
[31m-                <label asp-for="Descripcion" class="form-label small fw-bold text-uppercase text-muted">Descripción</label>[m
[31m-                <textarea asp-for="Descripcion" class="form-control rounded-0" rows="3"></textarea>[m
[31m-                <span asp-validation-for="Descripcion" class="text-danger small"></span>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="row">[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="SKU" class="form-label small fw-bold text-uppercase text-muted">SKU</label>[m
[31m-                    <input asp-for="SKU" class="form-control rounded-0" required />[m
[31m-                    <span asp-validation-for="SKU" class="text-danger small"></span>[m
[31m-                </div>[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="CategoriaId" class="form-label small fw-bold text-uppercase text-muted">Categoría</label>[m
[31m-                    <select asp-for="CategoriaId" class="form-select rounded-0" asp-items="ViewBag.CategoriaId" required></select>[m
[31m-                </div>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="row">[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="Precio" class="form-label small fw-bold text-uppercase text-muted">Precio ($)</label>[m
[31m-                    <input asp-for="Precio" type="number" step="0.01" class="form-control rounded-0" required />[m
[31m-                    <span asp-validation-for="Precio" class="text-danger small"></span>[m
[31m-                </div>[m
[31m-                <div class="col-md-6 mb-3">[m
[31m-                    <label asp-for="Stock" class="form-label small fw-bold text-uppercase text-muted">Stock Disponible</label>[m
[31m-                    <input asp-for="Stock" type="number" class="form-control rounded-0" required />[m
[31m-                    <span asp-validation-for="Stock" class="text-danger small"></span>[m
[31m-                </div>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="mb-4">[m
[31m-                <label asp-for="ImagenUrl" class="form-label small fw-bold text-uppercase text-muted">URL de la Imagen</label>[m
[31m-                <input asp-for="ImagenUrl" type="text" class="form-control rounded-0" />[m
[31m-                <span asp-validation-for="ImagenUrl" class="text-danger small"></span>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="d-flex justify-content-end gap-2">[m
[31m-                <a asp-action="Admin" class="btn btn-light rounded-0 btn-sm px-3">Cancelar</a>[m
[31m-                <button type="submit" class="btn btn-dark rounded-0 btn-sm px-4 fw-bold">Guardar Cambios</button>[m
[31m-            </div>[m
[31m-        </form>[m
[31m-    </div>[m
[31m-</div>[m
[31m-[m
[31m-@section Scripts {[m
[31m-    <partial name="_ValidationScriptsPartial" />[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/Views/Producto/Index.cshtml b/Views/Producto/Index.cshtml[m
[1mdeleted file mode 100644[m
[1mindex 76f60fc..0000000[m
[1m--- a/Views/Producto/Index.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,94 +0,0 @@[m
[31m-﻿@model IEnumerable<EcommerceImportados.Models.Producto>[m
[31m-[m
[31m-@{[m
[31m-    ViewData["Title"] = "Catálogo de Productos";[m
[31m-}[m
[31m-[m
[31m-<div class="container-fluid my-4 px-4">[m
[31m-    <div class="row">[m
[31m-        <aside class="col-md-3 col-lg-2 mb-4">[m
[31m-            <div class="mb-4">[m
[31m-                <h6 class="text-uppercase fw-bold text-muted small" style="letter-spacing: 0.05em;">Categoria</h6>[m
[31m-                @if (ViewBag.Categorias != null)[m
[31m-                {[m
[31m-                    foreach (var cat in (IEnumerable<EcommerceImportados.Models.Categoria>)ViewBag.Categorias)[m
[31m-                    {[m
[31m-                        <div class="form-check my-2">[m
[31m-                            <input class="form-check-input rounded-0" type="checkbox" id="cat-@cat.Id" value="@cat.Id">[m
[31m-                            <label class="form-check-label small text-dark" for="cat-@cat.Id">@cat.Nombre</label>[m
[31m-                        </div>[m
[31m-                    }[m
[31m-                }[m
[31m-                else[m
[31m-                {[m
[31m-                    <p class="text-muted small">No hay categorías cargadas.</p>[m
[31m-                }[m
[31m-            </div>[m
[31m-            <hr class="text-muted" />[m
[31m-        </aside>[m
[31m-[m
[31m-        <main class="col-md-9 col-lg-10">[m
[31m-            <div class="d-flex justify-content-between align-items-end mb-4">[m
[31m-                <div>[m
[31m-                    <h1 class="fw-bold h2 mb-1">Productos</h1>[m
[31m-                    <p class="text-muted small d-none d-md-block mb-0">Lista de productos</p>[m
[31m-                </div>[m
[31m-                <div class="d-flex align-items-center gap-2">[m
[31m-                    <span class="text-muted small text-nowrap">SORT BY</span>[m
[31m-                    <select class="form-select form-select-sm border-0 bg-light fw-semibold rounded-0">[m
[31m-                        <option>Newest</option>[m
[31m-                        <option>Price: Low to High</option>[m
[31m-                        <option>Price: High to Low</option>[m
[31m-                    </select>[m
[31m-                </div>[m
[31m-            </div>[m
[31m-[m
[31m-            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">[m
[31m-                @if (Model != null && Model.Any())[m
[31m-                {[m
[31m-                    foreach (var producto in Model)[m
[31m-                    {[m
[31m-                        <div class="col">[m
[31m-                            <div class="card h-100 border-0 rounded-0 shadow-sm">[m
[31m-                                <div class="position-relative overflow-hidden bg-light d-flex align-items-center justify-content-center" style="height: 280px; width: 100%;">[m
[31m-                                    <span class="position-absolute top-0 start-0 m-3 badge bg-light text-dark rounded-pill px-3 py-1 border" style="z-index: 10;">[m
[31m-                                        @producto.Categoria?.Nombre[m
[31m-                                    </span>[m
[31m-[m
[31m-                                    @if (!string.IsNullOrEmpty(producto.ImagenUrl))[m
[31m-                                    {[m
[31m-                                        <img src="@producto.ImagenUrl" alt="@producto.Nombre" class="w-100 h-100" style="object-fit: cover;">[m
[31m-                                    }[m
[31m-                                    else[m
[31m-                                    {[m
[31m-                                        <div class="text-center text-muted p-4">[m
[31m-                                            <i class="bi bi-image d-block h1 mb-1"></i>[m
[31m-                                            <span class="text-uppercase tracking-wider fw-semibold" style="font-size: 0.65rem; letter-spacing: 0.1em;">No Image Available</span>[m
[31m-                                        </div>[m
[31m-                                    }[m
[31m-                                </div>[m
[31m-[m
[31m-                                <div class="card-body p-3 d-flex flex-column justify-content-between">[m
[31m-                                    <div>[m
[31m-                                        <h5 class="card-title text-dark fw-semibold mb-2" style="font-size: 0.9rem; line-height: 1.4;">@producto.Nombre</h5>[m
[31m-                                        <p class="text-muted small text-truncate mb-0">@producto.Descripcion</p>[m
[31m-                                    </div>[m
[31m-                                    <div class="d-flex justify-content-between align-items-center mt-3">[m
[31m-                                        <p class="fw-bold text-dark mb-0">$@producto.Precio.ToString("N2")</p>[m
[31m-                                        <button class="btn btn-sm btn-dark rounded-0 text-uppercase px-2" style="font-size: 0.75rem;">+ Carrito</button>[m
[31m-                                    </div>[m
[31m-                                </div>[m
[31m-                            </div>[m
[31m-                        </div>[m
[31m-                    }[m
[31m-                }[m
[31m-                else[m
[31m-                {[m
[31m-                    <div class="col-12 text-center my-5">[m
[31m-                        <p class="text-muted">No se encontraron productos en esta sección.</p>[m
[31m-                    </div>[m
[31m-                }[m
[31m-            </div>[m
[31m-        </main>[m
[31m-    </div>[m
[31m-</div>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Shared/_Layout.cshtml b/Views/Shared/_Layout.cshtml[m
[1mindex d601fa6..ec3b6ac 100644[m
[1m--- a/Views/Shared/_Layout.cshtml[m
[1m+++ b/Views/Shared/_Layout.cshtml[m
[36m@@ -4,29 +4,47 @@[m
     <meta charset="utf-8" />[m
     <meta name="viewport" content="width=device-width, initial-scale=1.0" />[m
     <title>@ViewData["Title"] - EcommerceImportados</title>[m
[32m+[m[32m    <script type="importmap"></script>[m
     <link rel="stylesheet" href="~/lib/bootstrap/dist/css/bootstrap.min.css" />[m
     <link rel="stylesheet" href="~/css/site.css" asp-append-version="true" />[m
     <link rel="stylesheet" href="~/EcommerceImportados.styles.css" asp-append-version="true" />[m
[31m-    @await RenderSectionAsync("Styles", required: false)[m
 </head>[m
 <body>[m
[31m-    <partial name="_NavbarGlobal" />[m
[31m-[m
[31m-    <div class="container-fluid">[m
[32m+[m[32m    <header>[m
[32m+[m[32m        <nav class="navbar navbar-expand-sm navbar-toggleable-sm navbar-light bg-white border-bottom box-shadow mb-3">[m
[32m+[m[32m            <div class="container-fluid">[m
[32m+[m[32m                <a class="navbar-brand" asp-area="" asp-controller="Home" asp-action="Index">EcommerceImportados</a>[m
[32m+[m[32m                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target=".navbar-collapse" aria-controls="navbarSupportedContent"[m
[32m+[m[32m                        aria-expanded="false" aria-label="Toggle navigation">[m
[32m+[m[32m                    <span class="navbar-toggler-icon"></span>[m
[32m+[m[32m                </button>[m
[32m+[m[32m                <div class="navbar-collapse collapse d-sm-inline-flex justify-content-between">[m
[32m+[m[32m                    <ul class="navbar-nav flex-grow-1">[m
[32m+[m[32m                        <li class="nav-item">[m
[32m+[m[32m                            <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Index">Home</a>[m
[32m+[m[32m                        </li>[m
[32m+[m[32m                        <li class="nav-item">[m
[32m+[m[32m                            <a class="nav-link text-dark" asp-area="" asp-controller="Home" asp-action="Privacy">Privacy</a>[m
[32m+[m[32m                        </li>[m
[32m+[m[32m                    </ul>[m
[32m+[m[32m                </div>[m
[32m+[m[32m            </div>[m
[32m+[m[32m        </nav>[m
[32m+[m[32m    </header>[m
[32m+[m[32m    <div class="container">[m
         <main role="main" class="pb-3">[m
             @RenderBody()[m
         </main>[m
     </div>[m
 [m
[31m-    <footer class="border-top footer text-muted mt-5 py-3 bg-light">[m
[31m-        <div class="container text-center">[m
[31m-            &copy; 2026 - EcommerceImportados[m
[32m+[m[32m    <footer class="border-top footer text-muted">[m
[32m+[m[32m        <div class="container">[m
[32m+[m[32m            &copy; 2026 - EcommerceImportados - <a asp-area="" asp-controller="Home" asp-action="Privacy">Privacy</a>[m
         </div>[m
     </footer>[m
[31m-[m
     <script src="~/lib/jquery/dist/jquery.min.js"></script>[m
     <script src="~/lib/bootstrap/dist/js/bootstrap.bundle.min.js"></script>[m
     <script src="~/js/site.js" asp-append-version="true"></script>[m
     @await RenderSectionAsync("Scripts", required: false)[m
 </body>[m
[31m-</html>[m
\ No newline at end of file[m
[32m+[m[32m</html>[m
[1mdiff --git a/Views/Shared/_NavbarGlobal.cshtml b/Views/Shared/_NavbarGlobal.cshtml[m
[1mdeleted file mode 100644[m
[1mindex e50dbfb..0000000[m
[1m--- a/Views/Shared/_NavbarGlobal.cshtml[m
[1m+++ /dev/null[m
[36m@@ -1,22 +0,0 @@[m
[31m-﻿<!-- Views/Shared/_NavbarGlobal.cshtml -->[m
[31m-<header class="border-bottom bg-white sticky-top">[m
[31m-    <div class="container-fluid px-4 py-3 d-flex align-items-center justify-content-between">[m
[31m-        <!-- Logo -->[m
[31m-        <a class="navbar-brand fw-bold text-dark text-uppercase tracking-wider m-0 h4" asp-controller="Home" asp-action="Index">[m
[31m-            Global Imports[m
[31m-        </a>[m
[31m-[m
[31m-        <!-- NAVBAR -->[m
[31m-        <nav class="d-flex gap-4">[m
[31m-            <a asp-controller="Home" asp-action="Index" class="text-dark text-decoration-none small fw-semibold">Inicio</a>[m
[31m-            <a asp-controller="Producto" asp-action="Index" class="text-dark text-decoration-none small fw-semibold border-bottom border-dark pb-1">Productos</a>[m
[31m-            <a asp-controller="Carrito" asp-action="Index" class="text-muted text-decoration-none small fw-semibold">Carrito</a>[m
[31m-        </nav>[m
[31m-[m
[31m-        <!-- Admin  -->[m
[31m-        <div class="d-flex align-items-center">[m
[31m-            <a asp-controller="Categorias" asp-action="Index" class="btn btn-sm btn-outline-dark rounded-0 text-uppercase px-2 small fw-bold">Admin Cat</a>[m
[31m-            <a asp-controller="Producto" asp-action="Admin" class="btn btn-sm btn-outline-dark rounded-0 text-uppercase px-2 small fw-bold">Admin Prod</a>[m
[31m-        </div>[m
[31m-    </div>[m
[31m-</header>[m
\ No newline at end of file[m
[1mdiff --git a/Views/Shared/_NavbarGlobal.cshtml.cs b/Views/Shared/_NavbarGlobal.cshtml.cs[m
[1mdeleted file mode 100644[m
[1mindex 5434847..0000000[m
[1m--- a/Views/Shared/_NavbarGlobal.cshtml.cs[m
[1m+++ /dev/null[m
[36m@@ -1,12 +0,0 @@[m
[31m-using Microsoft.AspNetCore.Mvc;[m
[31m-using Microsoft.AspNetCore.Mvc.RazorPages;[m
[31m-[m
[31m-namespace EcommerceImportados.Views.Shared[m
[31m-{[m
[31m-    public class _NavbarGlobalModel : PageModel[m
[31m-    {[m
[31m-        public void OnGet()[m
[31m-        {[m
[31m-        }[m
[31m-    }[m
[31m-}[m
