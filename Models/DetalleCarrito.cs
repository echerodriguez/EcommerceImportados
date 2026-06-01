using Microsoft.EntityFrameworkCore;

namespace EcommerceImportados.Models
{
    public class DetalleCarrito
    {
        public int Id { get; set; }

        public int CarritoId { get; set; }

        public Carrito Carrito { get; set; } = null!;

        public int ProductoId { get; set; }

        public Producto Producto { get; set; } = null!;

        public int Cantidad { get; set; }

        [Precision(18, 2)]
        public decimal PrecioUnitario { get; set; }
    }
}