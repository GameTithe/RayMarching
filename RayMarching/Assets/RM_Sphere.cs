using UnityEngine;

public class RM_Sphere : MonoBehaviour
{
    Vector3 sphere1_pos;
    Vector3 sphere2_pos;
    
    public int _serialNum;
    public float _speed1 = 0.5f;
    public float _speed2 = 0.5f;
    Material _material;

     // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _material = GetComponent<Renderer>().material;
        //_material.SetInt("_Shape1", 0);

        sphere1_pos = transform.position - new Vector3(0, 0, 0);
        sphere2_pos = transform.position + new Vector3(0, 0, 0);
        _material.SetVector("_Sphere1_Pos", sphere1_pos);
        _material.SetVector("_Sphere2_Pos", sphere2_pos);

        _material.SetFloat("_Sphere1_R", 0.2f);
        _material.SetFloat("_Sphere2_R", 0.1f);


        _material.SetInt("_SerialNum", _serialNum);
        
    }

    // Update is called once per frame
    void Update()
    {
        float angle1 = Time.time * _speed1; 
        sphere1_pos = new Vector3(Mathf.Cos(angle1), Mathf.Sin(angle1), 0) *0.3f; 
       _material.SetVector("_Sphere1_Pos", sphere1_pos);

        float angle2 = Time.time * _speed2 * -1.0f;
        sphere2_pos = new Vector3( Mathf.Cos(angle2), Mathf.Sin(angle2), 0) * 0.3f; 
        _material.SetVector("_Sphere2_Pos", sphere2_pos);

    }
}
