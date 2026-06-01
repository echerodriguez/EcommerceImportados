using Microsoft.EntityFrameworkCore;

namespace EcommerceImportados.Models
{
    public class Pedido
    {
        public int Id { get; set; }

        public DateTime Fecha { get; set; }

        [Precision(18, 2)]
        public decimal Total { get; set; }

        public EstadoPedido Estado { get; set; }

        public int UsuarioId { get; set; }

        public Usuario Usuario { get; set; } = null!;

        public ICollection<DetallePedido> Detalles { get; set; }
            = new List<DetallePedido>();

        public bool Activo { get; set; } = true;
    }
}
