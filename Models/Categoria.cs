using System.ComponentModel.DataAnnotations;

namespace EcommerceImportados.Models
{
    public class Categoria
    {
        public ICollection<Producto> Productos { get; set; } = new List<Producto>();
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre de la categoría es obligatorio.")]
        [StringLength(20, ErrorMessage = "El nombre no puede superar los 20 caracteres.")]
        public string Nombre { get; set; } = string.Empty;

    }
}
