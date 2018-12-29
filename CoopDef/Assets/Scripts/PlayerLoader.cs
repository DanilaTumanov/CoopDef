using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;


public class PlayerLoader : NetworkBehaviour
{

    [SerializeField]
    private PlayerController _playerPrefab;


    public override void OnStartServer()
    {
        var player = Instantiate(_playerPrefab, transform.position, Quaternion.identity, null).gameObject;
        NetworkServer.SpawnWithClientAuthority(player, connectionToClient);
    }

}
