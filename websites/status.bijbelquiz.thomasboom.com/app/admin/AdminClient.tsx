"use client";

import { useEffect, useState } from "react";

type EventItem = {
  _id: string;
  title: string;
  description: string;
  type: "incident" | "maintenance";
  severity: "minor" | "major" | "critical";
  status: "ongoing" | "resolved" | "scheduled";
  impact: "app" | "website";
  startsAt: number;
  endsAt?: number;
};

const emptyForm: {
  title: string;
  description: string;
  type: EventItem["type"];
  severity: EventItem["severity"];
  status: EventItem["status"];
  impact: EventItem["impact"];
  startsAt: string;
  endsAt: string;
} = {
  title: "",
  description: "",
  type: "incident",
  severity: "minor",
  status: "ongoing",
  impact: "app",
  startsAt: "",
  endsAt: ""
};

const typeLabels: Record<EventItem["type"], string> = {
  incident: "Incident",
  maintenance: "Onderhoud"
};

const severityLabels: Record<EventItem["severity"], string> = {
  minor: "Gering",
  major: "Ernstig",
  critical: "Kritiek"
};

const statusLabels: Record<EventItem["status"], string> = {
  ongoing: "Lopend",
  resolved: "Afgerond",
  scheduled: "Gepland"
};

const impactLabels: Record<EventItem["impact"], string> = {
  app: "App",
  website: "Website"
};

function toLocalInput(value?: number) {
  if (!value) return "";
  const date = new Date(value);
  const local = new Date(date.getTime() - date.getTimezoneOffset() * 60000);
  return local.toISOString().slice(0, 16);
}

export default function AdminClient() {
  const [events, setEvents] = useState<EventItem[]>([]);
  const [form, setForm] = useState(emptyForm);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [editForm, setEditForm] = useState(emptyForm);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [draftIds, setDraftIds] = useState<string[]>([]);

  const loadEvents = async () => {
    const res = await fetch("/api/admin/events", { cache: "no-store" });
    if (res.ok) {
      const data = await res.json();
      setEvents(data.events);
    }
  };

  useEffect(() => {
    loadEvents();
  }, []);

  useEffect(() => {
    if (typeof window === "undefined") return;
    const stored = window.localStorage.getItem("status-admin-drafts");
    if (!stored) return;
    try {
      const parsed = JSON.parse(stored);
      if (Array.isArray(parsed)) {
        setDraftIds(parsed.filter((id) => typeof id === "string"));
      }
    } catch {
      setDraftIds([]);
    }
  }, []);

  useEffect(() => {
    if (typeof window === "undefined") return;
    window.localStorage.setItem("status-admin-drafts", JSON.stringify(draftIds));
  }, [draftIds]);

  useEffect(() => {
    if (!events.length || !draftIds.length) return;
    const validIds = new Set(events.map((event) => event._id));
    setDraftIds((prev) => prev.filter((id) => validIds.has(id)));
  }, [events, draftIds.length]);

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    setLoading(true);
    setMessage(null);

    const payload = {
      ...form,
      startsAt: form.startsAt ? new Date(form.startsAt).getTime() : Date.now(),
      endsAt: form.endsAt ? new Date(form.endsAt).getTime() : undefined
    };

    const res = await fetch("/api/admin/events", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const error = await res.json();
      setMessage(error.error ?? "Kon gebeurtenis niet aanmaken");
    } else {
      setForm(emptyForm);
      setMessage("Gebeurtenis aangemaakt.");
      await loadEvents();
    }
    setLoading(false);
  };

  const resolveEvent = async (id: string) => {
    setLoading(true);
    setMessage(null);
    const res = await fetch("/api/admin/events", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id })
    });

    if (!res.ok) {
      const error = await res.json();
      setMessage(error.error ?? "Kon gebeurtenis niet afronden");
    } else {
      setMessage("Gebeurtenis afgerond.");
      await loadEvents();
    }
    setLoading(false);
  };

  const updateStatus = async (
    eventItem: EventItem,
    nextStatus: EventItem["status"]
  ) => {
    setLoading(true);
    setMessage(null);

    const payload = {
      action: "update",
      id: eventItem._id,
      title: eventItem.title,
      description: eventItem.description,
      type: eventItem.type,
      severity: eventItem.severity,
      status: nextStatus,
      impact: eventItem.impact,
      startsAt: eventItem.startsAt,
      endsAt:
        nextStatus === "resolved"
          ? eventItem.endsAt ?? Date.now()
          : eventItem.endsAt
    };

    const res = await fetch("/api/admin/events", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const error = await res.json();
      setMessage(error.error ?? "Kon gebeurtenis niet bijwerken");
    } else {
      setMessage("Gebeurtenis bijgewerkt.");
      await loadEvents();
    }
    setLoading(false);
  };

  const updateImpact = async (
    eventItem: EventItem,
    nextImpact: EventItem["impact"]
  ) => {
    if (eventItem.impact === nextImpact) return;
    setLoading(true);
    setMessage(null);

    const payload = {
      action: "update",
      id: eventItem._id,
      title: eventItem.title,
      description: eventItem.description,
      type: eventItem.type,
      severity: eventItem.severity,
      status: eventItem.status,
      impact: nextImpact,
      startsAt: eventItem.startsAt,
      endsAt: eventItem.endsAt
    };

    const res = await fetch("/api/admin/events", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const error = await res.json();
      setMessage(error.error ?? "Kon impact van gebeurtenis niet bijwerken");
    } else {
      setMessage("Impact bijgewerkt.");
      await loadEvents();
    }
    setLoading(false);
  };

  const startEdit = (event: EventItem) => {
    setEditingId(event._id);
    setEditForm({
      title: event.title,
      description: event.description,
      type: event.type,
      severity: event.severity,
      status: event.status,
      impact: event.impact,
      startsAt: toLocalInput(event.startsAt),
      endsAt: toLocalInput(event.endsAt)
    });
  };

  const cancelEdit = () => {
    setEditingId(null);
    setEditForm(emptyForm);
  };

  const updateEvent = async (event: React.FormEvent) => {
    event.preventDefault();
    if (!editingId) return;
    setLoading(true);
    setMessage(null);

    const payload = {
      action: "update",
      id: editingId,
      ...editForm,
      startsAt: editForm.startsAt
        ? new Date(editForm.startsAt).getTime()
        : undefined,
      endsAt: editForm.endsAt ? new Date(editForm.endsAt).getTime() : undefined
    };

    const res = await fetch("/api/admin/events", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      const error = await res.json();
      setMessage(error.error ?? "Kon gebeurtenis niet bijwerken");
    } else {
      setMessage("Gebeurtenis bijgewerkt.");
      setEditingId(null);
      setEditForm(emptyForm);
      await loadEvents();
    }
    setLoading(false);
  };

  type ColumnKey = "draft" | "ongoing" | "planned" | "completed";

  const columns: { id: ColumnKey; label: string }[] = [
    { id: "draft", label: "Concept" },
    { id: "ongoing", label: "Lopend" },
    { id: "planned", label: "Gepland" },
    { id: "completed", label: "Afgerond" }
  ];

  const statusByColumn: Record<Exclude<ColumnKey, "draft">, EventItem["status"]> =
    {
      ongoing: "ongoing",
      planned: "scheduled",
      completed: "resolved"
    };

  const getColumnEvents = (column: ColumnKey) => {
    if (column === "draft") {
      const draftSet = new Set(draftIds);
      return events.filter((event) => draftSet.has(event._id));
    }
    const status = statusByColumn[column];
    const draftSet = new Set(draftIds);
    return events.filter(
      (event) => !draftSet.has(event._id) && event.status === status
    );
  };

  const onDragStart = (
    event: React.DragEvent<HTMLDivElement>,
    eventItem: EventItem
  ) => {
    event.dataTransfer.setData("text/plain", eventItem._id);
    event.dataTransfer.setData("text", eventItem._id);
    event.dataTransfer.effectAllowed = "move";
  };

  const readDragId = (event: React.DragEvent<HTMLDivElement>) =>
    event.dataTransfer.getData("text/plain") ||
    event.dataTransfer.getData("text");

  const allowDrop = (event: React.DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    event.dataTransfer.dropEffect = "move";
  };

  const onDropColumn = async (
    column: ColumnKey,
    event: React.DragEvent<HTMLDivElement>
  ) => {
    event.preventDefault();
    if (loading) return;
    const id = readDragId(event);
    if (!id) {
      setMessage("Kon de gesleepte gebeurtenis niet lezen.");
      return;
    }
    const eventItem = events.find((item) => item._id === id);
    if (!eventItem) return;

    if (column === "draft") {
      setDraftIds((prev) => (prev.includes(id) ? prev : [...prev, id]));
      return;
    }

    setDraftIds((prev) => prev.filter((draftId) => draftId !== id));
    const nextStatus = statusByColumn[column];
    if (eventItem.status === nextStatus) return;
    await updateStatus(eventItem, nextStatus);
  };

  const onDropLane = async (
    column: ColumnKey,
    impact: EventItem["impact"],
    event: React.DragEvent<HTMLDivElement>
  ) => {
    event.preventDefault();
    event.stopPropagation();
    if (loading) return;
    const id = readDragId(event);
    if (!id) {
      setMessage("Kon de gesleepte gebeurtenis niet lezen.");
      return;
    }
    const eventItem = events.find((item) => item._id === id);
    if (!eventItem) return;

    if (eventItem.impact !== impact) {
      await updateImpact(eventItem, impact);
    }

    if (column === "draft") {
      setDraftIds((prev) => (prev.includes(id) ? prev : [...prev, id]));
      return;
    }

    setDraftIds((prev) => prev.filter((draftId) => draftId !== id));
    const nextStatus = statusByColumn[column];
    if (eventItem.status === nextStatus) return;
    await updateStatus(eventItem, nextStatus);
  };

  return (
    <div className="container" style={{ paddingTop: 32 }}>
      <h1>Beheerconsole</h1>

      <section className="event-board" style={{ marginTop: 24 }}>
        <div className="board-grid">
          {columns.map((column) => (
            <div
              key={column.id}
              className="board-column"
              onDragOver={allowDrop}
              onDrop={(event) => onDropColumn(column.id, event)}
            >
              <div className="board-column-header">
                <h3>{column.label}</h3>
                <span className="subtitle">{getColumnEvents(column.id).length}</span>
              </div>
              <div className="board-column-body" onDragOver={allowDrop}>
                {(["website", "app"] as const).map((impact) => (
                  <div
                    key={impact}
                    className="impact-lane"
                    onDragOver={allowDrop}
                    onDrop={(event) => onDropLane(column.id, impact, event)}
                  >
                    <div className="impact-lane-header">
                      <span className={`badge impact-${impact}`}>
                        {impactLabels[impact]}
                      </span>
                      <span className="subtitle">
                        {
                          getColumnEvents(column.id).filter(
                            (item) => item.impact === impact
                          ).length
                        }
                      </span>
                    </div>
                    <div className="impact-lane-body">
                      {getColumnEvents(column.id)
                        .filter((item) => item.impact === impact)
                        .map((eventItem) => (
                  <div
                    key={eventItem._id}
                    className="board-card"
                    draggable
                    onDragStart={(event) => onDragStart(event, eventItem)}
                  >
                    <div className="board-card-title">
                      <strong>{eventItem.title}</strong>
                      <span className={`badge ${eventItem.type}`}>
                        {typeLabels[eventItem.type]}
                      </span>
                    </div>
                    <p className="subtitle board-card-date">
                      {new Date(eventItem.startsAt).toLocaleString()}
                    </p>
                    <p className="board-card-description">
                      {eventItem.description}
                    </p>
                    <div className="board-card-tags">
                      <span className={`badge ${eventItem.status}`}>
                        {statusLabels[eventItem.status]}
                      </span>
                      <span className={`badge impact-${eventItem.impact}`}>
                        {impactLabels[eventItem.impact]}
                      </span>
                      <span className={`badge severity-${eventItem.severity}`}>
                        {severityLabels[eventItem.severity]}
                      </span>
                    </div>
                    <div className="board-card-actions">
                      <button
                        className="button button-outline"
                        type="button"
                        onClick={() => startEdit(eventItem)}
                        disabled={loading}
                      >
                        Bewerken
                      </button>
                      {eventItem.status !== "resolved" ? (
                        <button
                          className="button button-outline"
                          type="button"
                          onClick={() => resolveEvent(eventItem._id)}
                          disabled={loading}
                        >
                          Afronden
                        </button>
                      ) : null}
                    </div>
                  </div>
                        ))}
                      {!getColumnEvents(column.id).filter(
                        (item) => item.impact === impact
                      ).length ? (
                        <div className="board-empty subtitle">
                          Geen gebeurtenissen.
                        </div>
                      ) : null}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </section>

      <form
        className="card"
        onSubmit={editingId ? updateEvent : submit}
        style={{ marginTop: 32 }}
      >
        <h3>{editingId ? "Gebeurtenis bewerken" : "Gebeurtenis aanmaken"}</h3>
        <div className="grid" style={{ marginTop: 16 }}>
          <label>
            Titel
            <input
              required
              value={editingId ? editForm.title : form.title}
              onChange={(e) =>
                editingId
                  ? setEditForm({ ...editForm, title: e.target.value })
                  : setForm({ ...form, title: e.target.value })
              }
              className="input"
            />
          </label>
          <label>
            Type
            <select
              value={editingId ? editForm.type : form.type}
              onChange={(e) =>
                editingId
                  ? setEditForm({
                      ...editForm,
                      type: e.target.value as EventItem["type"]
                    })
                  : setForm({
                      ...form,
                      type: e.target.value as EventItem["type"]
                    })
              }
              className="input"
            >
              <option value="incident">Incident</option>
              <option value="maintenance">Onderhoud</option>
            </select>
          </label>
          <label>
            Ernst
            <select
              value={editingId ? editForm.severity : form.severity}
              onChange={(e) =>
                editingId
                  ? setEditForm({
                      ...editForm,
                      severity: e.target.value as EventItem["severity"]
                    })
                  : setForm({
                      ...form,
                      severity: e.target.value as EventItem["severity"]
                    })
              }
              className="input"
            >
              <option value="minor">Gering</option>
              <option value="major">Ernstig</option>
              <option value="critical">Kritiek</option>
            </select>
          </label>
          <label>
            Status
            <select
              value={editingId ? editForm.status : form.status}
              onChange={(e) =>
                editingId
                  ? setEditForm({
                      ...editForm,
                      status: e.target.value as EventItem["status"]
                    })
                  : setForm({
                      ...form,
                      status: e.target.value as EventItem["status"]
                    })
              }
              className="input"
            >
              <option value="ongoing">Lopend</option>
              <option value="resolved">Afgerond</option>
              <option value="scheduled">Gepland</option>
            </select>
          </label>
          <label>
            Impact
            <select
              value={editingId ? editForm.impact : form.impact}
              onChange={(e) =>
                editingId
                  ? setEditForm({
                      ...editForm,
                      impact: e.target.value as EventItem["impact"]
                    })
                  : setForm({
                      ...form,
                      impact: e.target.value as EventItem["impact"]
                    })
              }
              className="input"
            >
              <option value="app">App</option>
              <option value="website">Website</option>
            </select>
          </label>
          <label>
            Starttijd
            <input
              type="datetime-local"
              value={editingId ? editForm.startsAt : form.startsAt}
              onChange={(e) =>
                editingId
                  ? setEditForm({ ...editForm, startsAt: e.target.value })
                  : setForm({ ...form, startsAt: e.target.value })
              }
              className="input"
            />
          </label>
          <label>
            Eindtijd (optioneel)
            <input
              type="datetime-local"
              value={editingId ? editForm.endsAt : form.endsAt}
              onChange={(e) =>
                editingId
                  ? setEditForm({ ...editForm, endsAt: e.target.value })
                  : setForm({ ...form, endsAt: e.target.value })
              }
              className="input"
            />
          </label>
        </div>
        <label style={{ marginTop: 16, display: "block" }}>
          Beschrijving
          <textarea
            required
            value={editingId ? editForm.description : form.description}
            onChange={(e) =>
              editingId
                ? setEditForm({ ...editForm, description: e.target.value })
                : setForm({ ...form, description: e.target.value })
            }
            className="input"
            rows={4}
          />
        </label>
        <div style={{ display: "flex", gap: 12, marginTop: 16 }}>
          <button type="submit" className="button" disabled={loading}>
            {loading
              ? "Bezig..."
              : editingId
              ? "Wijzigingen opslaan"
              : "Gebeurtenis publiceren"}
          </button>
          {editingId ? (
            <button
              type="button"
              className="button button-outline"
              onClick={cancelEdit}
              disabled={loading}
            >
              Annuleren
            </button>
          ) : null}
        </div>
      </form>

    </div>
  );
}
