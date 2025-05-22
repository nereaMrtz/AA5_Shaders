using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TerrainDeformation : MonoBehaviour
{
    [Header("Render Texture")]
    public Camera heightCam;
    public Vector2Int textureResolution = new Vector2Int(512, 512);
    public RenderTexture terrainMap;

    [Header("Material")]
    public Material terrainMaterial;

    [Header("Displacement Settings")]
    public float heightStrength = 10f;

    [Header("Height Zones")]
    public float zone1 = 3f;
    public float zone2 = 6f;
    public float blendMargin = 1f;

    void Start()
    {
        SetupRenderTexture();
        ApplySettings();
    }

    void Update()
    {
        if (!Application.isPlaying || Application.isPlaying)
        {
            ApplySettings();
        }
    }

    void SetupRenderTexture()
    {
        if (terrainMap == null)
        {
            terrainMap = new RenderTexture(textureResolution.x, textureResolution.y, 16, RenderTextureFormat.ARGB32);
            terrainMap.name = "Auto_HeightMap_RT";
            terrainMap.Create();
        }

        if (heightCam != null)
        {
            heightCam.targetTexture = terrainMap;
        }
    }

    void ApplySettings()
    {
        if (terrainMaterial == null || heightCam == null || terrainMap == null)
            return;

        terrainMaterial.SetTexture("_HeightMap", terrainMap);
        terrainMaterial.SetFloat("_HeightScale", heightStrength);
        terrainMaterial.SetFloat("_Zone1", zone1);
        terrainMaterial.SetFloat("_Zone2", zone2);
        terrainMaterial.SetFloat("_BlendWidth", blendMargin);

        // Calcular el espacio visible de la cámara ortográfica
        float h = heightCam.orthographicSize;
        float w = h * heightCam.aspect;

        Vector2 boundsMin = new Vector2(
            heightCam.transform.position.x - w,
            heightCam.transform.position.z - h
        );

        Vector2 boundsMax = new Vector2(
            heightCam.transform.position.x + w,
            heightCam.transform.position.z + h
        );

        terrainMaterial.SetVector("_BoundsMin", boundsMin);
        terrainMaterial.SetVector("_BoundsMax", boundsMax);
    }
}
