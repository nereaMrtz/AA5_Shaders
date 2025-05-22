
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public sealed class PingPostEffectRenderer : PostProcessEffectRenderer<PingPostEffect>
{
    private float pingTime;

    public override void Render(PostProcessRenderContext context)
    {
        pingTime += Time.deltaTime;

        Shader pingShader = Shader.Find("Hidden/Custom/PingPostEffect");
        if (pingShader == null)
        {
            Debug.LogError("Shader no encontrado con Shader.Find");
            return;
        }
        else
        {
            Debug.Log("Shader encontrado correctamente con Shader.Find");
        }

        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/PingPostEffect"));
        

        sheet.properties.SetFloat("_Strength", settings.strength);
        sheet.properties.SetColor("_Color", settings.color);
        sheet.properties.SetFloat("_Width", settings.width);
        sheet.properties.SetFloat("_Speed", settings.speed);
        sheet.properties.SetFloat("_MaxDistance", settings.maxDistance);
        sheet.properties.SetFloat("_Frequency", settings.frequency);
        sheet.properties.SetFloat("_TimeSincePing", pingTime);

        Vector2 screenCenter = new Vector2(Screen.width / 2f, Screen.height / 2f);
        Vector4 pingOrigin = new Vector4(screenCenter.x, screenCenter.y, Screen.width, Screen.height);
        sheet.properties.SetVector("_PingOrigin", pingOrigin);

        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}
