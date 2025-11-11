import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { corsHeaders } from "shared/cors.ts";

// --- LA SOLUCIÓN AL CRASH 500 ---
// 1. Usamos 'bcrypts' (con S)
import * as bcrypt from "https://deno.land/x/bcrypts@v0.3.0/mod.ts";

// 2. Damos tipo a 'req' para silenciar el error
serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { nombre_completo, email, telefono, password } = await req.json();

    if (!nombre_completo || !email || !telefono || !password) {
      throw new Error("Faltan campos obligatorios");
    }

    const supabaseClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    const { data: usuarioExistente, error: checkError } = await supabaseClient
      .from("usuarios")
      .select("id")
      .eq("email", email)
      .single();

    if (checkError && checkError.code !== 'PGRST116') {
      throw new Error("Error al verificar email");
    }

    if (usuarioExistente) {
      return new Response(JSON.stringify({ error: "El email ya está en uso" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 409,
      });
    }

    // --- LA SOLUCIÓN AL CRASH 500 ---
    // 3. Esta librería hashea de forma diferente (más simple)
    const hash_contrasena = await bcrypt.hash(password);

    const id_negocio = '1ce0008a-5361-4149-a709-93b6240e2cac';
    const id_rol = 2; // 2 = Cliente

    const { data: nuevoUsuario, error: insertError } = await supabaseClient
      .from("usuarios")
      .insert({
        id: crypto.randomUUID(),
        id_negocio: id_negocio,
        id_rol: id_rol,
        nombre_completo: nombre_completo,
        email: email,
        hash_contrasena: hash_contrasena,
        telefono: telefono,
        whatsapp: telefono,
        activo: true,
      })
      .select("id, nombre_completo, id_rol, email")
      .single();

    if (insertError) {
      console.error(insertError);
      throw new Error("No se pudo crear el usuario");
    }

    return new Response(JSON.stringify(nuevoUsuario), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 201,
    });

  } catch (err) {
    // 4. Damos tipo a 'err' para silenciar el error
    const error = err as Error;
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});