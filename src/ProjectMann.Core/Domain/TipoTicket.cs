using System;
using System.Collections.Generic;

#nullable disable

namespace ProjectMann.Web
{
    public partial class TipoTicket
    {
        public TipoTicket()
        {
            Tickets = new HashSet<Ticket>();
        }

        public short IdTipoTicket { get; set; }
        public string Nombre { get; set; }

        public virtual ICollection<Ticket> Tickets { get; set; }
    }
}
