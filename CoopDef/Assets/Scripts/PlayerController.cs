using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


[RequireComponent(typeof(NavMeshAgent))]
[RequireComponent(typeof(HealthController))]
public class PlayerController : MonoBehaviour
{

    private NavMeshAgent _NMA;


    private void Awake()
    {
        _NMA = GetComponent<NavMeshAgent>();
    }



    private void Update()
    {
        ProcessHandling();

        // DEBUG -----------------------------
        GetComponent<HealthController>().ReduceHealth(1 * Time.deltaTime);
    }




    private void ProcessHandling()
    {
        if (Input.GetMouseButtonDown(1))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

            if (Physics.Raycast(ray, out RaycastHit hitInfo, 100, 1 << LayerMask.NameToLayer("Ground"))){

                if(NavMesh.SamplePosition(hitInfo.point, out NavMeshHit hit, 5, NavMesh.AllAreas))
                {
                    _NMA.SetDestination(hit.position);
                }
            }
            
        }
    }

}
