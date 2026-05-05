import { getConvexClient, api } from "../lib/convex";

export const dynamic = "force-dynamic";
export const revalidate = 0;

function formatDate(value: number) {
  return new Intl.DateTimeFormat("nl-NL", {
    dateStyle: "medium",
    timeStyle: "short"
  }).format(new Date(value));
}

function statusCopy(status: "operational" | "degraded" | "major") {
  if (status === "major") {
    return {
      title: "Grote storing",
      subtitle: "We werken actief aan het oplossen van een kritieke storing.",
      color: "var(--error)"
    };
  }
  if (status === "degraded") {
    return {
      title: "Verminderde prestaties",
      subtitle: "Sommige diensten zijn trager dan normaal. Updates hieronder.",
      color: "var(--warning)"
    };
  }
  return {
    title: "Alle systemen operationeel",
    subtitle: "",
    color: "var(--success)"
  };
}

function labelType(type: "incident" | "maintenance") {
  return type === "incident" ? "Incident" : "Onderhoud";
}

function labelStatus(status: "ongoing" | "resolved" | "scheduled") {
  if (status === "resolved") return "Opgelost";
  if (status === "scheduled") return "Gepland";
  return "Lopend";
}

function labelImpact(impact?: "app" | "website") {
  return impact === "website" ? "Website" : "App";
}

export default async function StatusPage() {
  const client = getConvexClient();
  const status = await client.query(api.events.getStatus, { windowDays: 90 });
  const copy = statusCopy(status.currentStatus);
  const activeEvents = status.events.filter(
    (event: any) => event.status === "ongoing"
  );
  const recentEvents = status.events.filter(
    (event: any) => event.status !== "ongoing"
  );

  return (
    <main>
      <div className="container">
        <header className="hero-layout">
          <div className="hero-content">
            <div className="hero-text">
              <span className="material-icons icon-large" aria-hidden>
                church
              </span>
              <h1>BijbelQuiz Status</h1>
              <p className="hero-description">
                Live service-status, incident-updates en gepland onderhoud voor
                het BijbelQuiz-platform.
              </p>
            </div>
            <div className="status-row">
              <div className="status-pill">
                <span
                  className="status-dot"
                  style={{ background: copy.color }}
                />
                {copy.title}
              </div>
              <span className="status-updated">
                Laatst bijgewerkt: {formatDate(status.lastUpdated)}
              </span>
            </div>
            {copy.subtitle ? <p className="subtitle">{copy.subtitle}</p> : null}
          </div>
          <div className="summary-panel">
            <div className="summary-card">
              <span className="summary-label">Uptime (90 dagen)</span>
              <span className="summary-value">
                {status.uptimePercent.toFixed(3)}%
              </span>
            </div>
            <div className="summary-card">
              <span className="summary-label">Actieve incidenten</span>
              <span className="summary-value">{activeEvents.length}</span>
            </div>
            <div className="summary-card">
              <span className="summary-label">Incidenten in venster</span>
              <span className="summary-value">{status.events.length}</span>
            </div>
          </div>
        </header>

        <div className="section-title">
          <div>
            <h2>Actieve incidenten</h2>
            <p className="subtitle">Wat nu aandacht vraagt.</p>
          </div>
        </div>

        <section className="event-list">
          {activeEvents.length === 0 ? (
            <div className="event">
              <div className="event-header">
                <h3>Geen actieve incidenten</h3>
                <span className="badge resolved">Oké</span>
              </div>
              <p className="subtitle">
                Er zijn op dit moment geen lopende incidenten of onderhoud.
              </p>
            </div>
          ) : (
            activeEvents.map((event: any) => (
              <article className="event" key={event._id}>
                <div className="event-header">
                  <div>
                    <h3>{event.title}</h3>
                    <p className="subtitle">
                      {formatDate(event.startsAt)} · Lopend
                    </p>
                  </div>
                  <div style={{ display: "flex", gap: 8 }}>
                    <span className={`badge ${event.type}`}>
                      {labelType(event.type)}
                    </span>
                    <span className={`badge impact-${event.impact}`}>
                      {labelImpact(event.impact)}
                    </span>
                    <span className={`badge ${event.status}`}>
                      {labelStatus(event.status)}
                    </span>
                  </div>
                </div>
                <p className="subtitle" style={{ marginTop: 12 }}>
                  {event.description}
                </p>
              </article>
            ))
          )}
        </section>

        <div className="section-title">
          <div>
            <h2>Recente updates</h2>
            <p className="subtitle">Meest recente incidenten en onderhoud.</p>
          </div>
        </div>

        <section className="event-list">
          {recentEvents.length === 0 ? (
            <div className="event">
              <div className="event-header">
                <h3>Geen recente updates</h3>
              </div>
              <p className="subtitle">Er zijn geen recente meldingen.</p>
            </div>
          ) : (
            recentEvents.map((event: any) => (
              <article className="event" key={event._id}>
                <div className="event-header">
                  <div>
                    <h3>{event.title}</h3>
                    <p className="subtitle">
                      {formatDate(event.startsAt)}
                      {event.endsAt
                        ? ` · Opgelost ${formatDate(event.endsAt)}`
                        : " · Lopend"}
                    </p>
                  </div>
                  <div style={{ display: "flex", gap: 8 }}>
                    <span className={`badge ${event.type}`}>
                      {labelType(event.type)}
                    </span>
                    <span className={`badge impact-${event.impact}`}>
                      {labelImpact(event.impact)}
                    </span>
                    <span className={`badge ${event.status}`}>
                      {labelStatus(event.status)}
                    </span>
                  </div>
                </div>
                <p className="subtitle" style={{ marginTop: 12 }}>
                  {event.description}
                </p>
              </article>
            ))
          )}
        </section>

      </div>
    </main>
  );
}
