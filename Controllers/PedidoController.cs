using EcommerceImportados.Data;
using EcommerceImportados.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace EcommerceImportados.Controllers;

[Authorize]
public class PedidoController : Controller
{
    private readonly ApplicationDbContext _context;

    public PedidoController(ApplicationDbContext context)
    {
        _context = context;
    }

    [Authorize(Roles = "RolAdministrador")]
    public async Task<IActionResult> CambiarEstado(
        int id,
        EstadoPedido nuevoEstado)
    {
        var pedido = await _context.Pedidos.FindAsync(id);

        if (pedido == null)
            return NotFound();

        pedido.Estado = nuevoEstado;

        await _context.SaveChangesAsync();

        return RedirectToAction("Index");
    }

    [Authorize]
    public async Task<IActionResult> Cancelar(int id)
    {
        int usuarioId = int.Parse(
            User.FindFirst(ClaimTypes.NameIdentifier)!.Value);

        var pedido = await _context.Pedidos.FindAsync(id);

        if (pedido == null)
            return NotFound();

        if (pedido.UsuarioId != usuarioId)
            return Forbid();

        if (pedido.Estado == EstadoPedido.Pagado)
        {
            return RedirectToAction(
                "HistorialCompras",
                "Account");
        }

        pedido.Estado = EstadoPedido.Cancelado;

        await _context.SaveChangesAsync();

        return RedirectToAction(
            "HistorialCompras",
            "Account");
    }


}
