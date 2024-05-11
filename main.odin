package main

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "Game Stuff")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	playerPos := rl.Vector2{640, 320}
	playerVel: rl.Vector2
	playerGrounded: bool
	playerWalkTexture := rl.LoadTexture("advnt_full.png")
	playerWalkTextureFrames := 6
	player_run_frame_timer: f32
	player_run_frame_length: f32 = 0.1
	player_run_current_frame: int
	player_filp: bool
	player_jump_frame_timer: f32
	player_jump_frame_length: f32 = 0.4
	player_jump_current_frame: int


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLUE)

		if rl.IsKeyDown(.LEFT) {
			playerVel.x = -400
			player_filp = true
		} else if rl.IsKeyDown(.RIGHT) {
			playerVel.x = 400
			player_filp = false
		} else {
			playerVel.x = 0
			player_run_current_frame = 0
		}


		playerVel.y += 2000 * rl.GetFrameTime()

		if playerGrounded && rl.IsKeyPressed(.SPACE) {
			playerVel.y = -600
			playerGrounded = false
		}

		playerPos += rl.GetFrameTime() * playerVel

		if (playerPos.y > f32(rl.GetScreenHeight() - playerWalkTexture.height * 4 / 10)) {
			playerPos.y = f32(rl.GetScreenHeight() - playerWalkTexture.height * 4 / 10)
			playerGrounded = true
		}

		if (playerPos.x > f32(rl.GetScreenWidth() - 64)) {

		}

		playerTextureWidth := f32(playerWalkTexture.width)
		playerTextureHeight := f32(playerWalkTexture.height)

		player_run_frame_timer += rl.GetFrameTime()

		if (player_run_frame_timer > player_run_frame_length && playerVel.x != 0) {
			player_run_current_frame += 1
			player_run_frame_timer = 0
			if (player_run_current_frame == 7) {
				player_run_current_frame = 1
			}
		}

		player_jump_frame_timer += rl.GetFrameTime()

		if (player_jump_frame_timer > player_jump_frame_length &&
			   playerVel.y < 0 &&
			   !playerGrounded) {
			player_jump_current_frame += 1
			player_jump_frame_timer = 0
			if (player_jump_current_frame == 4) {
				player_jump_current_frame = 3
			}
		}
		if (playerGrounded) {
			player_jump_current_frame = 0
		}

		playerWalkSource := rl.Rectangle {
			f32(player_run_current_frame) * f32(playerTextureWidth / 10),
			0,
			f32(playerTextureWidth / 10),
			f32(playerTextureHeight / 10),
		}

		playerJumpSource := rl.Rectangle {
			f32(player_jump_current_frame) * f32(playerTextureWidth / 10) * 7.0,
			f32(playerTextureHeight / 10),
			f32(playerTextureWidth / 10),
			f32(playerTextureHeight / 10),
		}

		if player_filp {
			playerWalkSource.width = -playerWalkSource.width
			playerJumpSource.width = -playerJumpSource.width
		}

		playerWalkDest := rl.Rectangle {
			x      = playerPos.x,
			y      = playerPos.y,
			width  = (playerTextureWidth / 10) * 4,
			height = (playerTextureHeight / 10) * 4,
		}

		playerJumpDestination := rl.Rectangle {
			x      = playerPos.x,
			y      = playerPos.y,
			width  = (playerTextureWidth / 10) * 4,
			height = (playerTextureHeight / 10) * 4,
		}

		if (playerGrounded) {
			rl.DrawTexturePro(playerWalkTexture, playerWalkSource, playerWalkDest, 0, 0, rl.WHITE)
		} else {
			rl.DrawTexturePro(
				playerWalkTexture,
				playerJumpSource,
				playerJumpDestination,
				0,
				0,
				rl.WHITE,
			)
		}

		rl.DrawFPS(1200, 0)

		rl.EndDrawing()
	}
}
