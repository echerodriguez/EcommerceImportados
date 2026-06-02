using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace EcommerceImportados.Models
{
    public class Producto
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre del producto es obligatorio.")]
        [StringLength(100)]
        public string Nombre { get; set; } = string.Empty;

        [StringLength(500)]
        public string Descripcion { get; set; } = string.Empty;

        [Required(ErrorMessage = "El SKU es obligatorio.")]
        public string SKU { get; set; } = string.Empty;

        [Required(ErrorMessage = "El precio es obligatorio.")]
        [Precision(18, 2)]
        [Range(0.01, double.MaxValue, ErrorMessage = "El precio debe ser mayor a cero.")]
        public decimal Precio { get; set; }

        [Required(ErrorMessage = "El stock es obligatorio.")]
        [Range(0, int.MaxValue, ErrorMessage = "El stock no puede ser un número negativo.")]
        public int Stock { get; set; }

        public string? ImagenUrl { get; set; }

        [Required(ErrorMessage = "La categoría es obligatoria.")]
        public int CategoriaId { get; set; }

        public Categoria? Categoria { get; set; }

        public ICollection<DetalleCarrito> DetallesCarrito { get; set; }
            = new List<DetalleCarrito>();

        public ICollection<DetallePedido> DetallesPedido { get; set; } 
            = new List<DetallePedido>();
    }
}
