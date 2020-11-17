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
    public class ItemTrabajoController : Controller
    {
        private readonly ProjectMannDbContext _context;

        public ItemTrabajoController(ProjectMannDbContext context)
        {
            _context = context;
        }

        // GET: ItemTrabajo
        public async Task<IActionResult> Index()
        {
            var projectMannDbContext = _context.ItemTrabajos.Include(i => i.FkAsignadoANavigation).Include(i => i.FkEstadoNavigation).Include(i => i.FkTipoItemTrabajoNavigation).Include(i => i.FkUsuarioCreaNavigation).Include(i => i.FkUsuarioModificaNavigation);
            return View(await projectMannDbContext.ToListAsync());
        }

        // GET: ItemTrabajo/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var itemTrabajo = await _context.ItemTrabajos
                .Include(i => i.FkAsignadoANavigation)
                .Include(i => i.FkEstadoNavigation)
                .Include(i => i.FkTipoItemTrabajoNavigation)
                .Include(i => i.FkUsuarioCreaNavigation)
                .Include(i => i.FkUsuarioModificaNavigation)
                .FirstOrDefaultAsync(m => m.IdItemTrabajo == id);
            if (itemTrabajo == null)
            {
                return NotFound();
            }

            return View(itemTrabajo);
        }

        // GET: ItemTrabajo/Create
        public IActionResult Create()
        {
            ViewData["FkAsignadoA"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido");
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre");
            ViewData["FkTipoItemTrabajo"] = new SelectList(_context.TipoItemTrabajos, "IdTipoItemTrabajo", "Nombre");
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido");
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido");
            return View();
        }

        // POST: ItemTrabajo/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdItemTrabajo,FkTipoItemTrabajo,Titulo,Descripcion,FkEstado,FkAsignadoA,FechaCreacion,FechaModificacion,FkUsuarioModifica,FkUsuarioCrea")] ItemTrabajo itemTrabajo)
        {
            if (ModelState.IsValid)
            {
                _context.Add(itemTrabajo);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["FkAsignadoA"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkAsignadoA);
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre", itemTrabajo.FkEstado);
            ViewData["FkTipoItemTrabajo"] = new SelectList(_context.TipoItemTrabajos, "IdTipoItemTrabajo", "Nombre", itemTrabajo.FkTipoItemTrabajo);
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkUsuarioCrea);
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkUsuarioModifica);
            return View(itemTrabajo);
        }

        // GET: ItemTrabajo/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var itemTrabajo = await _context.ItemTrabajos.FindAsync(id);
            if (itemTrabajo == null)
            {
                return NotFound();
            }
            ViewData["FkAsignadoA"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkAsignadoA);
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre", itemTrabajo.FkEstado);
            ViewData["FkTipoItemTrabajo"] = new SelectList(_context.TipoItemTrabajos, "IdTipoItemTrabajo", "Nombre", itemTrabajo.FkTipoItemTrabajo);
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkUsuarioCrea);
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkUsuarioModifica);
            return View(itemTrabajo);
        }

        // POST: ItemTrabajo/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdItemTrabajo,FkTipoItemTrabajo,Titulo,Descripcion,FkEstado,FkAsignadoA,FechaCreacion,FechaModificacion,FkUsuarioModifica,FkUsuarioCrea")] ItemTrabajo itemTrabajo)
        {
            if (id != itemTrabajo.IdItemTrabajo)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(itemTrabajo);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ItemTrabajoExists(itemTrabajo.IdItemTrabajo))
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
            ViewData["FkAsignadoA"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkAsignadoA);
            ViewData["FkEstado"] = new SelectList(_context.Estados, "IdEstado", "Nombre", itemTrabajo.FkEstado);
            ViewData["FkTipoItemTrabajo"] = new SelectList(_context.TipoItemTrabajos, "IdTipoItemTrabajo", "Nombre", itemTrabajo.FkTipoItemTrabajo);
            ViewData["FkUsuarioCrea"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkUsuarioCrea);
            ViewData["FkUsuarioModifica"] = new SelectList(_context.Usuarios, "IdUsuario", "Apellido", itemTrabajo.FkUsuarioModifica);
            return View(itemTrabajo);
        }

        // GET: ItemTrabajo/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var itemTrabajo = await _context.ItemTrabajos
                .Include(i => i.FkAsignadoANavigation)
                .Include(i => i.FkEstadoNavigation)
                .Include(i => i.FkTipoItemTrabajoNavigation)
                .Include(i => i.FkUsuarioCreaNavigation)
                .Include(i => i.FkUsuarioModificaNavigation)
                .FirstOrDefaultAsync(m => m.IdItemTrabajo == id);
            if (itemTrabajo == null)
            {
                return NotFound();
            }

            return View(itemTrabajo);
        }

        // POST: ItemTrabajo/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var itemTrabajo = await _context.ItemTrabajos.FindAsync(id);
            _context.ItemTrabajos.Remove(itemTrabajo);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ItemTrabajoExists(int id)
        {
            return _context.ItemTrabajos.Any(e => e.IdItemTrabajo == id);
        }
    }
}
