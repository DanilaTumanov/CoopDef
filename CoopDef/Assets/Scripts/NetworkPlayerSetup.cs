using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class NetworkPlayerSetup : NetworkBehaviour
{

    [SerializeField]
    private Behaviour[] _authorityBehaviours;


    private void Awake()
    {
        SetActiveAuthorityBehaviours(false);
    }


    public override void OnStartAuthority()
    {
        // При получении прав на объект проверяем, есть ли права на управление им

        if (hasAuthority)
        {
            SetActiveAuthorityBehaviours();
            Camera.main.GetComponent<CameraFollow>().Target = transform;
        }
    }

    /// <summary>
    /// Отключить скрипты, которые требуют права на управление объектом
    /// </summary>
    private void SetActiveAuthorityBehaviours(bool active = true)
    {        
        for (int i = 0; i < _authorityBehaviours.Length; i++)
        {
            _authorityBehaviours[i].enabled = active;
        }
    }

}
