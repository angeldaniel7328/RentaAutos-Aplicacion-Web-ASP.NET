﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BussinesLogic;
using Entities;

namespace Presentation.Catalogo.Automoviles
{
    public partial class EditarAutomovil : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["Id"] == null)
                {
                    Response.Redirect("ListaAutomoviles.aspx");
                }
                else
                {
                    bool disponibilidad = true;
                    string idAutomovil = Request.QueryString["Id"].ToString();
                    VOAutomovil automovil = BLLAutomovil.ConsultarAutomovilPorId(idAutomovil);
                    CargarFormulario(automovil);
                    disponibilidad = (bool)automovil.Disponibilidad;
                    if (disponibilidad)
                    {
                        lblAutomovil.ForeColor = System.Drawing.Color.Green;
                        btnEliminar.Visible = true;
                    }
                    else
                    {
                        lblAutomovil.ForeColor = System.Drawing.Color.Red;
                        btnEliminar.Visible = false;
                    }
                }
            }
        }

        private void CargarFormulario(VOAutomovil automovil)
        {
            lblAutomovil.Text = automovil.IdAutomovil.ToString();
            txtMatricula.Text = automovil.Matricula.ToString();
            txtModelo.Text = automovil.Modelo.ToString();
            txtMarca.Text = automovil.Marca.ToString();
            txtCuota.Text = automovil.Cuota.ToString();
            lblUrlFoto.InnerText = automovil.UrlFoto.ToString();
            imgFotoAutomovil.ImageUrl = automovil.UrlFoto;
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                BLLAutomovil.EliminarAutomovil(lblAutomovil.Text);
                LimpiarFormulario();
                Response.Redirect("ListaAutomoviles.aspx");
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, GetType(), $"Mensaje de error",
                    "alert(Se registró un error al realizar la operación " + ex.Message + ");", true);
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                VOAutomovil automovil = new VOAutomovil
                {
                    IdAutomovil = int.Parse(lblAutomovil.Text),
                    Matricula = txtMatricula.Text,
                    Modelo = txtModelo.Text,
                    Marca = txtMarca.Text,
                    Cuota = double.Parse(txtCuota.Text),
                    UrlFoto = lblUrlFoto.InnerText,
                    Disponibilidad = true
                };
                BLLAutomovil.ActualizarAutomovil(automovil);
                LimpiarFormulario();
                Response.Redirect("ListaAutomoviles.aspx");
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterClientScriptBlock(this, GetType(), $"Mensaje de error",
                    "alert(Se registró un error al realizar la operación " + ex.Message + ");", true);
            }
        }

        protected void btnSubirImagen_Click(object sender, EventArgs e)
        {
            if (SubirImagen.Value.Length > 0)
            {
                var fileName = Path.GetFileName(SubirImagen.PostedFile.FileName);
                var extension = Path.GetExtension(fileName).ToLower();
                if (extension != ".jpg" && extension != ".png")
                {
                    lblUrlFoto.InnerText = "Archivo no valido";
                    return;
                }
                var path = Server.MapPath("~/Imagenes/Automoviles/");
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                SubirImagen.PostedFile.SaveAs(path + fileName);
                var url = "/Imagenes/Automoviles/" + fileName;
                lblUrlFoto.InnerText = url;
                imgFotoAutomovil.ImageUrl = url;
                btnGuardar.Visible = true;
            }
        }

        private void LimpiarFormulario()
        {
            lblAutomovil.Text = string.Empty;
            txtMatricula.Text = string.Empty;
            txtModelo.Text = string.Empty;
            txtMarca.Text = string.Empty;
            txtCuota.Text = string.Empty;
            lblUrlFoto.InnerText = string.Empty;
            imgFotoAutomovil.ImageUrl = string.Empty;
            btnGuardar.Visible = true;
        }

    }
}