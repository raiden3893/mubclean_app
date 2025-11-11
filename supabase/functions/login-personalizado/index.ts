import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "shared/cors.ts";

// --- LA SOLUCIÓN AL CRASH 500 ---
// 1. Usamos 'bcrypts' (con S)
import * as bcrypt from "https://deno.land/x/bcrypts@v0.3.0/mod.ts";

// 2. Damos tipo a 'req'
serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { email, password } = await req.json();
    if (!email || !password) {
      throw new Error("Faltan email o contraseña");
    }

    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { data: usuario, error: userError } = await supabaseClient
      .from("usuarios")
      .select("id, nombre_completo, id_rol, hash_contrasena")
      .eq("email", email)
      .single();

    if (userError || !usuario) {
      return new Response(JSON.stringify({ error: "Credenciales inválidas" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 401,
      });
    }

    // (La función 'compare' funciona igual en ambas librerías)
    const passwordValida = await bcrypt.compare(password, usuario.hash_contrasena);

    if (!passwordValida) {
      return new Response(JSON.stringify({ error: "Credenciales inválidas" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 401,
      });
    }

    const datosUsuario = {
      id: usuario.id,
      nombre_completo: usuario.nombre_completo,
      id_rol: usuario.id_rol,
    };

    return new Response(JSON.stringify(datosUsuario), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });

  } catch (err) {
    // 3. Damos tipo a 'err'
    const error = err as Error;
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});