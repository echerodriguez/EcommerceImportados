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

        public decimal PrecioUnitario { get; set; }
    }
}