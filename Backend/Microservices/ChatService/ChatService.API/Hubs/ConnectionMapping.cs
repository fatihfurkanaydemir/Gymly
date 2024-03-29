﻿namespace ChatService.API.Hubs;

public class ConnectionMapping<T>
{
  private readonly Dictionary<T, HashSet<string>> _connections =
      new Dictionary<T, HashSet<string>>();

  public int Count
  {
    get
    {
      return _connections.Count;
    }
  }

  public void Add(T key, string connectionId)
  {
    lock (_connections)
    {
      HashSet<string> connections;
      if (!_connections.TryGetValue(key, out connections))
      {
        connections = new HashSet<string>();
        _connections.Add(key, connections);
      }

      lock (connections)
      {
        connections.Add(connectionId);
      }
    }
  }

  public void Remove(T key, string connectionId)
  {
    lock (_connections)
    {
      HashSet<string> connections;
      if (_connections.TryGetValue(key, out connections))
      {
        connections.Remove(connectionId);
        _connections[key] = connections;
      }
    }
  }

  public IEnumerable<string> GetConnections(T key)
  {
    HashSet<string> connections;

    if (_connections.TryGetValue(key, out connections))
    {
      return connections;
    }

    return Enumerable.Empty<string>();
  }
}
