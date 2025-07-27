using UnityEngine;

[ExecuteAlways, RequireComponent(typeof(Renderer))]
public class BoundingBoxUpdater : MonoBehaviour
{
    void Awake()
    {
        var renderer = GetComponent<Renderer>();

        var mat = renderer.sharedMaterial;
        if (mat == null || mat.shader.name != "Unlit/CylinderWrapperShader")
            return;

        renderer.bounds = new Bounds(Vector3.zero, Vector3.one * 1000);
    }
}
