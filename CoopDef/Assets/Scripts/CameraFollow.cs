using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    [SerializeField]
    private Transform _target;

    [SerializeField]
    private Vector3 _offset = new Vector3(0, 35, 25);

    [SerializeField]
    private float _rotation = -45;



    public Transform Target { get => _target; set => _target = value; }



    private void LateUpdate()
    {
        if(_target != null)
        {
            transform.position = _target.position + _offset;
            transform.LookAt(_target, Vector3.up);
            transform.RotateAround(_target.position, Vector3.up, _rotation);
        }
    }

}
