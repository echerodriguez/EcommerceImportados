using EcommerceImportados.Data;
using EcommerceImportados.Models;
using EcommerceImportados.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Identity;

namespace EcommerceImportados.Controllers;

public class AccountController : Controller
{
    private readonly ApplicationDbContext _context;

    public AccountController(ApplicationDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public IActionResult Login()
    {
        return View(new LoginViewModel());
    }

    [HttpPost]
    public async Task<IActionResult> Login(LoginViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        Usuario? usuario = _context.Usuarios
            .FirstOrDefault(u => u.Email == model.Email);

        if (usuario == null)
        {
            ModelState.AddModelError("",
                "Email o contraseña incorrectos");

            return View(model);
        }

        var passwordHasher = new PasswordHasher<Usuario>();

        var resultado = passwordHasher.VerifyHashedPassword(
            usuario,
            usuario.Password,
            model.Password);

        if (resultado == PasswordVerificationResult.Failed)
        {
            ModelState.AddModelError("",
                "Email o contraseña incorrectos");

            return View(model);
        }

        var claims = new List<Claim>
    {
        new Claim(ClaimTypes.NameIdentifier,
                  usuario.Id.ToString()),

        new Claim(ClaimTypes.Name,
                  usuario.Nombre),

        new Claim(ClaimTypes.Email,
                  usuario.Email),

        new Claim(ClaimTypes.Role,
                  usuario.Rol.ToString())
    };

        var identity = new ClaimsIdentity(
            claims,
            CookieAuthenticationDefaults.AuthenticationScheme);

        var principal = new ClaimsPrincipal(identity);

        await HttpContext.SignInAsync(
            CookieAuthenticationDefaults.AuthenticationScheme,
            principal);

        return RedirectToAction("Index", "Home");
    }

    [HttpGet]
    public IActionResult Register()
    {
        return View(new RegisterViewModel());
    }

    [HttpPost]
    public async Task<IActionResult> Register(RegisterViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        bool emailExiste = _context.Usuarios
            .Any(u => u.Email == model.Email);

        if (emailExiste)
        {
            ModelState.AddModelError("Email",
                "Ya existe un usuario con ese email.");

            return View(model);
        }

        Usuario usuario = new Usuario
        {
            Nombre = model.Nombre,
            Apellido = model.Apellido,
            Email = model.Email,
            DNI = model.DNI
        };

        var passwordHasher = new PasswordHasher<Usuario>();

        usuario.Password = passwordHasher.HashPassword(
            usuario,
            model.Password);

        _context.Usuarios.Add(usuario);

        await _context.SaveChangesAsync();

        Carrito carrito = new Carrito
        {
            UsuarioId = usuario.Id
        };

        _context.Carritos.Add(carrito);

        await _context.SaveChangesAsync();

        return RedirectToAction("Login");
    }

    [Authorize]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(
            CookieAuthenticationDefaults.AuthenticationScheme);

        return RedirectToAction("Index", "Home");
    }

    [Authorize(Roles = "RolAdministrador")]
    public IActionResult TestAdmin()
    {
        return Content("Sos administrador");
    }

    [Authorize]
    public IActionResult TestUsuario()
    {
        return Content("Estás logueado");
    }

    [Authorize]
    public IActionResult HistorialCompras()
    {
        int usuarioId = int.Parse(
            User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        var pedidos = _context.Pedidos
            .Where(p => p.UsuarioId == usuarioId)
            .OrderByDescending(p => p.Fecha)
            .ToList();

        return View(pedidos);
    }

    [Authorize]
    public IActionResult Index()
    {
        int usuarioId = int.Parse(
            User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        var usuario = _context.Usuarios
            .FirstOrDefault(u => u.Id == usuarioId);

        if (usuario == null)
            return NotFound();

        return View(usuario);
    }
}
