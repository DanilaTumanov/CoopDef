using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class HealthController : MonoBehaviour
{
    [SerializeField]
    private Slider _HPBarPrefab;

    [SerializeField]
    private float _MaxHP = 100;

    [SerializeField]
    private float _HPBarOffset = 8;


    [SyncVar]
    private float _HP;

    private Slider _HPBar;



    public float HP => _HP;



    private void Awake()
    {
        var HUD = GameObject.FindGameObjectWithTag("HUD");

        _HPBar = Instantiate(_HPBarPrefab, HUD.transform);
    }


    private void Update()
    {
        _HPBar.transform.position = Camera.main.WorldToScreenPoint(transform.position + Vector3.up * _HPBarOffset);
        _HPBar.value = _HP / _MaxHP;
    }


    public void ReduceHealth(float amount)
    {
        _HP -= amount;
    }


    public void SetHP(float amount)
    {
        _HP = amount;
    }

}
