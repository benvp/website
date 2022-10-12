defmodule BenvpWeb.WizardLive do
  use BenvpWeb, :live_view

  require Logger

  alias BenvpWeb.WizardLive

  import LiveMotion

  @steps [
    :step_1,
    :step_2,
    :step_3,
    :step_4,
    :step_5
  ]

  def mount(%{"step" => step}, _session, socket) do
    {:ok, assign(socket, step: String.to_existing_atom(step))}
  end

  def mount(_params, _session, socket) do
    socket = push_redirect(socket, to: Routes.live_path(socket, WizardLive, :step_1))
    {:ok, socket}
  end

  def handle_params(%{"step" => step}, _uri, socket) do
    {:noreply, assign(socket, step: String.to_existing_atom(step))}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, step: :step_1)}
  end

  def handle_event("set_step", %{"step" => step}, socket) do
    {:noreply, assign(socket, step: String.to_existing_atom(step))}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-screen-md mx-auto flex flex-col items-center mt-12">
      <div class="bg-slate-800 py-14 px-20 rounded-xl shadow-lg">
        <div class="flex items-center justify-between h-6">
          <.presence id="back-presence" class="flex-1">
            <%= if @step in [:step_2, :step_3] do %>
              <.motion
                id="back-circle"
                class="text-benvp-green flex-1"
                initial={[y: -10, opacity: 0]}
                animate={[y: 0, opacity: 1]}
                exit={[y: 10, opacity: 0]}
              >
                <%= live_patch to: Routes.live_path(@socket, WizardLive, prev_step(@step)) do %>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="3"
                    stroke="currentColor"
                    class="w-6 h-6"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M10.5 19.5L3 12m0 0l7.5-7.5M3 12h18"
                    />
                  </svg>
                <% end %>
              </.motion>
            <% end %>
          </.presence>

          <div class="flex-1 flex space-x-12">
            <.motion
              id="step1-circle"
              class="rounded-full w-4 h-4 border-2 border-benvp-green"
              animate={
                [
                  background:
                    if(@step in [:step_2, :step_3, :step_4], do: "#00FFBF", else: "transparent"),
                  scale: if(@step == :step_1, do: 1.5, else: 1)
                ]
              }
            >
            </.motion>
            <.motion
              id="step2-circle"
              class="rounded-full w-4 h-4 border-2 border-benvp-green"
              animate={
                [
                  background: if(@step in [:step_3, :step_4], do: "#00FFBF", else: "transparent"),
                  scale: if(@step == :step_2, do: 1.7, else: 1)
                ]
              }
            >
            </.motion>
            <.motion
              id="step3-circle"
              class="rounded-full w-4 h-4 border-2 border-benvp-green"
              animate={
                [
                  background: if(@step in [:step_4], do: "#00FFBF", else: "transparent"),
                  scale: if(@step == :step_3, do: 1.5, else: 1)
                ]
              }
            >
            </.motion>
          </div>

          <div class="flex-1"></div>
        </div>

        <.presence id="form-presence" class="mt-10">
          <%= if @step == :step_1 do %>
            <.motion
              id="step-1-container"
              class="space-y-4"
              initial={[x: 10, opacity: 0]}
              animate={[x: 0, opacity: 1]}
              exit={[x: -10, opacity: 0]}
            >
              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-1-option-1"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 1
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the first option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>

              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-1-option-2"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 2
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the second option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>

              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-1-option-3"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 3
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the third option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>
            </.motion>
          <% end %>

          <%= if @step == :step_2 do %>
            <.motion
              id="step-2-container"
              class="space-y-4"
              initial={[x: 10, opacity: 0]}
              animate={[x: 0, opacity: 1]}
              exit={[x: -10, opacity: 0]}
            >
              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-2-option-1"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 1
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the first option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>

              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-2-option-2"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 2
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the second option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>
            </.motion>
          <% end %>

          <%= if @step == :step_3 do %>
            <.motion
              id="step-3-container"
              class="space-y-4"
              initial={[x: 10, opacity: 0]}
              animate={[x: 0, opacity: 1]}
              exit={[x: -10, opacity: 0]}
            >
              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-3-option-1"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 1
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the first option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>

              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-3-option-2"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 2
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the second option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>

              <%= live_patch to: Routes.live_path(@socket, WizardLive, next_step(@step)), class: "block" do %>
                <.motion
                  id="step-3-option-3"
                  class="bg-slate-600 px-6 py-4 flex items-center justify-between rounded-lg shadow-md hover:cursor-pointer"
                  hover={[x: 4, background: "#64748b"]}
                  transition={
                    [duration: 0.6, easing: [spring: [stiffness: 400, damping: 20, friction: 0]]]
                  }
                  press={[scale: 0.98, y: 2, x: 4]}
                >
                  <div class="rounded-full text-slate-200 w-12 h-12 bg-slate-400 flex justify-center items-center shadow">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      class="w-6 h-6"
                    >
                      <path d="M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" />
                    </svg>
                  </div>
                  <div class="ml-6 flex-1">
                    <div class="text-slate-200">
                      This is option 3
                    </div>
                    <div class="text-sm text-slate-400">
                      Here is some caption for the third option.
                    </div>
                  </div>
                  <div class="ml-6 text-benvp-green">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="3"
                      stroke="currentColor"
                      class="w-4 h-4"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3"
                      />
                    </svg>
                  </div>
                </.motion>
              <% end %>
            </.motion>
          <% end %>

          <%= if @step == :step_4 do %>
            <.motion
              id="step-4-container"
              class="space-y-4"
              initial={[scale: 0.5, opacity: 0]}
              animate={[scale: 1, opacity: 1]}
              transition={[easing: [spring: [stiffness: 300, damping: 10, friction: 20]]]}
            >
              <div class="flex space-x-6 items-center">
                <div class="text-4xl">🎉</div>
                <div class="text-2xl font-bold">Finished</div>
              </div>
            </.motion>
          <% end %>
        </.presence>
      </div>
    </div>
    """
  end

  defp next_step(current) do
    index = Enum.find_index(@steps, &(&1 == current))
    Enum.at(@steps, index + 1)
  end

  defp prev_step(current) do
    index = Enum.find_index(@steps, &(&1 == current))
    Enum.at(@steps, index - 1)
  end
end
