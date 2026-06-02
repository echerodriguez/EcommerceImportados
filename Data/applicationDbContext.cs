using EcommerceImportados.Controllers;
using EcommerceImportados.Models;
using Microsoft.EntityFrameworkCore;

namespace EcommerceImportados.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(
            DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Usuario> Usuarios { get; set; }

        public DbSet<Producto> Productos { get; set; }

        public DbSet<Categoria> Categorias { get; set; }

        public DbSet<Carrito> Carritos { get; set; }

        public DbSet<DetalleCarrito> DetallesCarrito { get; set; }

        public DbSet<Pedido> Pedidos { get; set; }

        public DbSet<DetallePedido> DetallesPedido { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Server=(localdb)\\mssqllocaldb;Database=EcommerceImportadosDb;Trusted_Connection=True;");
        }
    }
}