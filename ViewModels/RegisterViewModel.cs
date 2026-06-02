using System.ComponentModel.DataAnnotations;

namespace EcommerceImportados.ViewModels
{
    public class RegisterViewModel
    {
        [Required]
        public string Nombre { get; set; } = "";

        [Required]
        public string Apellido { get; set; } = "";

        [Required]
        [EmailAddress]
        public string Email { get; set; } = "";

        [Required]
        [RegularExpression(@"^\d{7,8}$")]
        public string DNI { get; set; } = "";

        [Required]
        [MinLength(8)]
        public string Password { get; set; } = "";
    }
}