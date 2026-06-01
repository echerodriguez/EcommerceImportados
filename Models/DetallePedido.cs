using Microsoft.EntityFrameworkCore;

namespace EcommerceImportados.Models
{
    public class DetallePedido
    {
        public int Id { get; set; }

        public int PedidoId { get; set; }
        
        public Pedido Pedido { get; set; } = null!;

        public int ProductoId { get; set; }

        public Producto Producto { get; set; } = null!;

        public int Cantidad { get; set; }

        [Precision(18, 2)]
        public decimal PrecioUnitario { get; set; }
    }
}
