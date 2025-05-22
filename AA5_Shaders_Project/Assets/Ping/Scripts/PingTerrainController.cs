
using UnityEngine;

public class PingTerrainController : MonoBehaviour
{
    public Material terrainMaterial;
    public Transform pingOrigin;
    public float pingSpeed = 15f;
    public float pingWidth = 3f;
    //public Color pingColor = Color.yellow;

    private float pingTime;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            pingTime = 0f;
        }

        pingTime += Time.deltaTime;

        if (terrainMaterial != null && pingOrigin != null)
        {
            terrainMaterial.SetFloat("_TimeSincePing", pingTime);
            terrainMaterial.SetVector("_PingOriginWS", pingOrigin.position);
            terrainMaterial.SetFloat("_PingSpeed", pingSpeed);
            terrainMaterial.SetFloat("_PingWidth", pingWidth);
            //terrainMaterial.SetColor("_PingColor", pingColor);
        }
    }
}
