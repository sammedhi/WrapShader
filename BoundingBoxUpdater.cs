using UnityEngine;

public class BoundingBoxUpdater : MonoBehaviour
{
    // Start is called before the first frame update

    private Material mat;

    void Start()
    {
        var renderer = GetComponent<Renderer>();
        if (renderer == null)
            return;

        var mat = renderer.material;
        if (mat == null)
            return;

        if (mat.shader.name != "Unlit/WrapShader")
            return;

        FixBoundingBox(renderer, mat);
    }

    private void FixBoundingBox(Renderer renderer, Material mat)
    {
        float wrapWidth = mat.GetFloat("_GameWidth");
        var newCenter = TransformPoint(renderer.bounds.center, wrapWidth);
        renderer.bounds = new Bounds(newCenter, Vector3.one * 1000);
    }

    private Vector3 TransformPoint(Vector3 point, float wrapWidth)
    {
        float percent = point.x / (wrapWidth / 2f);
        float angle = percent * Mathf.PI;
        float radius = point.z;
        return new Vector3(Mathf.Sin(angle), point.y / radius, Mathf.Cos(angle)) * radius;
    }
}
