GRANT EXECUTE ON FUNCTION public.is_membro_sala(UUID, UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_mestre_sala(UUID, UUID) TO authenticated;

DROP POLICY IF EXISTS "Entrar na sala" ON public.sala_jogadores;
CREATE POLICY "Entrar na sala" ON public.sala_jogadores FOR INSERT TO authenticated
  WITH CHECK (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.salas WHERE id = sala_id AND mestre_id = auth.uid())
  );

DROP POLICY IF EXISTS "Atualiza proprio registro ou mestre" ON public.sala_jogadores;
CREATE POLICY "Atualiza proprio registro ou mestre" ON public.sala_jogadores FOR UPDATE TO authenticated
  USING (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.salas WHERE id = sala_id AND mestre_id = auth.uid())
  )
  WITH CHECK (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.salas WHERE id = sala_id AND mestre_id = auth.uid())
  );

DROP POLICY IF EXISTS "Sai da sala ou mestre remove" ON public.sala_jogadores;
CREATE POLICY "Sai da sala ou mestre remove" ON public.sala_jogadores FOR DELETE TO authenticated
  USING (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM public.salas WHERE id = sala_id AND mestre_id = auth.uid())
  );

DROP POLICY IF EXISTS "Membros da sala veem o draft" ON public.sala_draft;
CREATE POLICY "Membros da sala veem o draft" ON public.sala_draft FOR SELECT TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.sala_jogadores WHERE sala_id = sala_draft.sala_id AND user_id = auth.uid())
    OR EXISTS (SELECT 1 FROM public.salas WHERE id = sala_draft.sala_id AND mestre_id = auth.uid())
  );

DROP POLICY IF EXISTS "Membros da sala veem o torneio" ON public.torneio_online;
CREATE POLICY "Membros da sala veem o torneio" ON public.torneio_online FOR SELECT TO authenticated
  USING (
    EXISTS (SELECT 1 FROM public.sala_jogadores WHERE sala_id = torneio_online.sala_id AND user_id = auth.uid())
    OR EXISTS (SELECT 1 FROM public.salas WHERE id = torneio_online.sala_id AND mestre_id = auth.uid())
  );