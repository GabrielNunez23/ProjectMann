using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ProjectMann.Web;

namespace ProjectMann.Web.Controllers
{
    public class ProyectoController : Controller
    {
        private readonly ProjectMannDbContext _context;

        public ProyectoController(ProjectMannDbContext context)
        {
            _context = context;
        }

        // GET: Proyecto
        public async Task<IActionResult> Index()
        {
            var projectMannDbContext = _context.Proyectos.Include(p => p.FkClienteNavigation).Include(p => p.FkEstadoNavigation).Include(p => p.FkUsuarioCreaNavigation).Include(p => p.FkUsuarioModificaNavigation);
            return View(await projectMannDbContext.ToListAsync());
        }

        // GET: Proyecto/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var proyecto = await _context.Proyectos
                .Include(p => p.FkClienteNavigation)
                .Include(p => p.FkEstadoNavigation)
                .Include(p => p.FkUsuarioCreaNavigation)
                .Include(p => p.FkUsuarioModificaNavigation)
                .FirstOrDefaultAsync(m => m.IdProyecto == id);
            if (proyecto == null)
            {
                return NotFound();
            }

            return View(proyecto);
        }

        // GET: Proyecto/Create
        public IActionResult Create()
        {
            ViewData["FkCliente"] = new SelectList(_context.Clientes, "IdCliente", "Celular");
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre");
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido");
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido");
            return View();
        }

        // POST: Proyecto/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdProyecto,NombreProyecto,FkEstado,FkCliente,FechaCreacion,FechaModificacion,FkUsuarioModifica,FkUsuarioCrea")] Proyecto proyecto)
        {
            if (ModelState.IsValid)
            {
                _context.Add(proyecto);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["FkCliente"] = new SelectList(_context.Clientes, "IdCliente", "Celular", proyecto.FkCliente);
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre", proyecto.FkEstado);
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", proyecto.FkUsuarioCrea);
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", proyecto.FkUsuarioModifica);
            return View(proyecto);
        }

        // GET: Proyecto/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var proyecto = await _context.Proyectos.FindAsync(id);
            if (proyecto == null)
            {
                return NotFound();
            }
            ViewData["FkCliente"] = new SelectList(_context.Clientes, "IdCliente", "Celular", proyecto.FkCliente);
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre", proyecto.FkEstado);
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", proyecto.FkUsuarioCrea);
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", proyecto.FkUsuarioModifica);
            return View(proyecto);
        }

        // POST: Proyecto/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdProyecto,NombreProyecto,FkEstado,FkCliente,FechaCreacion,FechaModificacion,FkUsuarioModifica,FkUsuarioCrea")] Proyecto proyecto)
        {
            if (id != proyecto.IdProyecto)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(proyecto);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ProyectoExists(proyecto.IdProyecto))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["FkCliente"] = new SelectList(_context.Clientes, "IdCliente", "Celular", proyecto.FkCliente);
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre", proyecto.FkEstado);
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", proyecto.FkUsuarioCrea);
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", proyecto.FkUsuarioModifica);
            return View(proyecto);
        }

        // GET: Proyecto/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var proyecto = await _context.Proyectos
                .Include(p => p.FkClienteNavigation)
                .Include(p => p.FkEstadoNavigation)
                .Include(p => p.FkUsuarioCreaNavigation)
                .Include(p => p.FkUsuarioModificaNavigation)
                .FirstOrDefaultAsync(m => m.IdProyecto == id);
            if (proyecto == null)
            {
                return NotFound();
            }

            return View(proyecto);
        }

        // POST: Proyecto/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var proyecto = await _context.Proyectos.FindAsync(id);
            _context.Proyectos.Remove(proyecto);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ProyectoExists(int id)
        {
            return _context.Proyectos.Any(e => e.IdProyecto == id);
        }
    }
}
