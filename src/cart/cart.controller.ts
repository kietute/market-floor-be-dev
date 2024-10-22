import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { CartService } from './cart.service';
import { AddProductToCartDto } from './dtos/add-product-to-cart.dto';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { User } from '../entities/user.entity';
import { AuthGuard } from '../common/guards/auth.guard';

@Controller('cart')
export class CartController {
  constructor(private cartService: CartService) {}

  @Post()
  @UseGuards(AuthGuard)
  async createCart(@CurrentUser() user: User) {
    return this.cartService.createCart(user);
  }

  @Post('/add-product')
  @UseGuards(AuthGuard)
  async addProductToCart(@Body() body: AddProductToCartDto) {
    return this.cartService.addProductToCart(body);
  }

  @Get('/:id')
  @UseGuards(AuthGuard)
  async getCartDetails(@Param('id') id: number) {
    return this.cartService.getCartDetails(id);
  }

  @Delete('/remove-product/:cartDetailId')
  @UseGuards(AuthGuard)
  async removeProductFromCart(@Param('cartDetailId') cartDetailId: number) {
    return this.cartService.removeProductFromCart(cartDetailId);
  }

  @Delete('/clear/:cartId')
  @UseGuards(AuthGuard)
  async clearCart(@Param('cartId') cartId: number) {
    return this.cartService.clearCart(cartId);
  }
}
