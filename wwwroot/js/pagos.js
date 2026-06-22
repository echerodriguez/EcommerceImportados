document.getElementById("numeroTarjeta")
    .addEventListener("input", function (e) {

        let valor = e.target.value;

        valor = valor.replace(/\D/g, '');
        valor = valor.substring(0, 16);
        valor = valor.replace(/(\d{4})(?=\d)/g, '$1 ');

        e.target.value = valor;

        mostrarIconoTarjeta(valor);
    });


function limpiarNumeroTarjeta(numero) {
    return numero.replace(/\D/g, '');
}


function mostrarIconoTarjeta(numeroConFormato) {

    const numero =
        numeroConFormato.replace(/\D/g, '');

    const icono =
        document.getElementById("iconoTarjeta");

    if (numero.length === 0) {
        icono.style.display = "none";
        icono.src = "";
        icono.alt = "";
    }
    else if (esVisa(numero)) {
        icono.style.display = "inline";
        icono.src = "/img/tarjetas/Visa.png";
        icono.alt = "Visa";
    }
    else if (esMasterCard(numero)) {
        icono.style.display = "inline";
        icono.src = "/img/tarjetas/Mastercard.png";
        icono.alt = "MasterCard";
    }
    else {
        icono.style.display = "none";
        icono.src = "";
        icono.alt = "";
    }
}


function esVisa(numero) {
    return /^4/.test(numero);
}


function esMasterCard(numero) {
    return /^(5[1-5]|2[2-7])/.test(numero);
}


document.getElementById("vencimiento")
    .addEventListener("blur", function (e) {

        const vencimiento =
            e.target.value;

        if (vencimiento.length === 0) {
            return;
        }

        if (!vencimientoValido(vencimiento)) {
            alert("La fecha de vencimiento no es válida o la tarjeta está vencida.");
            e.target.value = "";
        }
    });

function vencimientoValido(vencimiento) {

    if (!/^\d{2}\/\d{2}$/.test(vencimiento)) {
        return false;
    }

    const partes =
        vencimiento.split("/");

    const mes =
        parseInt(partes[0], 10);

    const anio =
        parseInt(partes[1], 10);

    if (mes < 1 || mes > 12) {
        return false;
    }

    const fechaActual =
        new Date();

    const mesActual =
        fechaActual.getMonth() + 1;

    const anioActual =
        fechaActual.getFullYear() % 100;

    if (anio < anioActual) {
        return false;
    }

    if (anio === anioActual && mes < mesActual) {
        return false;
    }

    return true;
}


document.getElementById("cvv")
    .addEventListener("input", function (e) {

        e.target.value =
            e.target.value
                .replace(/\D/g, '')
                .substring(0, 3);
    });


document.getElementById("toggleCvv")
    .addEventListener("click", function () {

        const cvv =
            document.getElementById("cvv");

        if (cvv.type === "password") {
            cvv.type = "text";
        }
        else {
            cvv.type = "password";
        }
    });


document.getElementById("formPago")
    .addEventListener("submit", async function (e) {

        e.preventDefault();

        const formData =
            new FormData(this);

        try {

            const response =
                await fetch(
                    "/Pagos/ConfirmarPago",
                    {
                        method: "POST",
                        body: formData
                    });

            const resultado =
                await response.json();

            if (resultado.success) {

                alert(resultado.mensaje);

                window.location.href =
                    "/Account/historialcompras";
            }
            else {

                alert(resultado.mensaje);
            }

        } catch (error) {

            alert("Ocurrió un error al procesar el pago.");
        }
    });