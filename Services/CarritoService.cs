using EcommerceImportados.Data;

namespace EcommerceImportados.Services
{
    public class CarritoService
    {
        private readonly ApplicationDbContext _context;

        public CarritoService(ApplicationDbContext context)
        {
            _context = context;
        }

        public void AgregarProducto(int productoId)
        {

        }

        public decimal ObtenerTotal()
        {
            return 0m;
        }
    }
}
